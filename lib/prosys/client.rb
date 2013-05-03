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
      http.request(request)
    end

    def extract_response response
      puts "<- #{response.body}" if debug
      response.body
    end

    def api
      @api ||= SimpleProxy.new(self, :post)
    end

    private
    def symbol_to_class_name sym
      sym.to_s.camelize
    end
  end
end
