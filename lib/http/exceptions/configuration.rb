# frozen_string_literal: true

# Some stdlib need to be required for accessing those error classes
# Required for bundler 1.14.5
require "net/http"
require "openssl"
require "socket"

module Http
  module Exceptions
    class Configuration
      DEFAULT_EXCEPTIONS_TO_CONVERT = [
        SocketError,
        Errno::ETIMEDOUT,
        (Net.const_defined?(:ReadTimeout) ? Net::ReadTimeout : EOFError),
        (Net.const_defined?(:OpenTimeout) ? Net::OpenTimeout : EOFError),
        Net::ProtocolError,
        Errno::ECONNREFUSED,
        Errno::EHOSTDOWN,
        Errno::ECONNRESET,
        Errno::ENETUNREACH,
        Errno::EHOSTUNREACH,
        Errno::ECONNABORTED,
        OpenSSL::SSL::SSLError,
        EOFError,
      ].uniq.freeze

      # Exception classes to be converted to Http::Exceptions::HttpException
      attr_accessor :exceptions_to_convert

      def initialize
        self.exceptions_to_convert = DEFAULT_EXCEPTIONS_TO_CONVERT
      end
    end
  end
end
