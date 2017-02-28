require "http/exceptions/version"
require "http/exceptions/configuration"
require "http/exceptions/http_exception"

module Http
  module Exceptions
    def self.wrap_exception
      begin
        yield
      rescue *configuration.exceptions_to_convert => e
        raise HttpException.new original_exception: e
      end
    end

    def self.check_response!(res)
      raise HttpException.new(response: res) unless (200...300).include?(res.code.to_i)
      res
    end

    def self.wrap_and_check
      wrap_exception do
        check_response! yield
      end
    end

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   Http::Exceptions.configure do |config|
    #     config.exceptions_to_convert = [Net::ProtocolError]
    #     config.exceptions_to_convert << EOFError
    #   end
    def self.configure
      yield(configuration)
      self
    end

    # The configuration object.
    # @see Http::Exceptions.configure
    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end
