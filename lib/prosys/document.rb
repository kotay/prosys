require 'active_support/core_ext/string'
require 'builder'

module Prosys
  class Payload
    def initialize attributes = {}
      @attributes = attributes
      @doc        = Builder::XmlMarkup.new
    end

    def prosys_name
      "Prosys_%s_REQUEST" % self.class.name.split('::').last.underscore.upcase
    end

    def build opts = {}
      #doc.instruct!(:xml, :encoding => 'UTF-8')
      self._build(opts)
      doc.target!
    end

    private
    def doc
      @doc
    end
  end

  class SimpleInlineDocument
    def _build opts = {}
      doc.tag!(self.prosys_name, opts)
    end
  end
end

Dir[File.dirname(__FILE__) + "/payloads/*.rb"].each do |file|
  require file
end
