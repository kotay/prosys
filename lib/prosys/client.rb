require 'crack'
require 'net/http'
require 'uri'
require 'pry'


module Prosys
  class Client
    API_VERSION = '1.0'
    ENDPOINT = 'https://secure.provu.co.uk/eSys/xml.pl'

    attr_reader :username, :password, :testing, :debug

    def initialize(opts = {})
      @username            = opts[:username]
      @password            = opts[:password]
      @testing             = opts[:testing] ? true : false
      @debug               = opts[:debug] ? true : false
    end

    def post(document_name, opts = {})
      klass = symbol_to_class_name(document_name)
      document = Prosys.const_defined?(klass) ? Prosys.const_get(klass) : Prosys.const_missing(klass)
      post_document document, opts
    end

    def post_document(document, opts = {})
      xml = document.new(:api_version          => API_VERSION,
                         :client_id            => @username,
                         :client_authorization => @password,
                         :testing              => @testing).build(opts)
      extract_response(send_request(xml))
    end

    def send_request(xml)
      uri                     = URI.parse(ENDPOINT)
      http                    = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl            = (uri.scheme == 'https')
      request                 = Net::HTTP::Post.new(uri.request_uri)
      request.body            = xml
      request["Content-Type"] = "text/xml"
      request.basic_auth @username, @password
      puts "-> #{request.body}" if debug
      # DON'T MAKE AN ORDER IF TESTING!
      http.request(request) unless testing
    end

    def extract_response response
      unless testing
        puts "<- #{response.body}" if debug
        response.body
      else
        puts "Test mode [Didn't send anything]" if debug
      end
    end

    def api
      @api ||= SimpleProxy.new(self, :post)
    end

    def get(action, params={})
      additional          = params.to_query
      uri                 = URI.parse("https://secure.provu.co.uk/prosys/#{action}.php?XML=yes&#{additional}")
      http                = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl        = true
      request             = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth @username, @password
      response            = http.request(request)
      Crack::XML.parse(response.body)
    end

    def create_order(order)
      api.create_order(order)
    end

    def price_list
      @get ||= get("price_list")["stock"]["line"]
    end
    
    def order_history
      get("order_history")["orders"]["order"]
    end

    def outstanding_orders
      get("order_history", {:outstanding => "yes"})
    end

    def item(item)
      price_list.select {|i| i["item"] == item }[0]
    end

    def stock(item)
      stock = item(item)["free_stock"].to_i
      {:in_stock => in_stock?(item), :amount => stock}
    end

    def in_stock?(item)
      stock = item(item)["free_stock"].to_i > 0
    end

    def weight?(item)
      item(item)["weight"]
    end

    def price?(item)
      item(item)["retail_price"]
    end

    def order(order_id)
      get("order_status", {:ordid => order_id })["order"]
    end

    def order_by_ref(cus_ref_id)
      get("order_status", {"cusRefnum" => cus_ref_id })["order"]
    end

    def order_status(order_id)
      order(order_id)["done"]
    end

    def order_released(order_id)
      order(order_id)["released"]
    end

    private
    def symbol_to_class_name sym
      sym.to_s.camelize
    end
  end
end
