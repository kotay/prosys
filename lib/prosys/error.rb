module Prosys
  class APIError < StandardError
    attr_accessor :prosys_error_type, :prosys_error_message
    def initialize(details = {})
      self.prosys_error_type    = details['type']
      self.prosys_error_message = details['message']
      super("#{prosys_error_type}: #{prosys_error_message}")
    end
  end
end
