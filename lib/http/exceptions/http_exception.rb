module Http
  module Exceptions
    class HttpException < RuntimeError
      attr_reader :response, :original_exception

      def initialize(options = {})
        @original_exception = options[:original_exception]
        @response = options[:response]
        msg = "An error as occurred while processing response."
        msg += " Status #{response.code}\n#{response.body}" if response
        msg += " Original Exception: #{original_exception}" if original_exception
        super msg
      end
    end
  end
end
