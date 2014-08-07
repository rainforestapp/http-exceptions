module Http
  module Exceptions
    class HttpException < RuntimeError
      attr_reader :response, :original_exception

      def initialize(original_exception: nil, response: nil)
        @response = response
        @original_exception = original_exception
        msg = "An error as occured while processing response."
        msg += " Status #{response.code}\n#{response.body}" if response
        msg += " Original Exception: #{original_exception}" if original_exception
        super msg
      end
    end
  end
end
