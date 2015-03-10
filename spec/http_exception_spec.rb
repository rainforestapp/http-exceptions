require 'spec_helper'

describe Http::Exceptions do
  let(:invalid_response) { double(code: 400, body: '') }
  let(:valid_response) { double(code: 200) }

  class TestException < RuntimeError
  end

  describe ".wrap_exception" do
    let(:supported_exception_class) { Http::Exceptions::Configuration::DEFAULT_EXCEPTIONS_TO_CONVERT.first }
    let(:unsupported_exception_class) { TestException }

    context "when exception class is supported" do
      before { expect(Http::Exceptions.configuration.exceptions_to_convert).to include(supported_exception_class) }

      it "raises an HttpException on supported http exceptions" do
        expect do
          described_class.wrap_exception do
            raise supported_exception_class
          end
        end.to raise_error(Http::Exceptions::HttpException)
      end

      it "saves the original exception against the HttpException" do
        begin
          described_class.wrap_exception do
            raise supported_exception_class
          end
        rescue Http::Exceptions::HttpException => e
          expect(e.original_exception).to be_a(supported_exception_class)
        end
      end
    end

    context "when exception class is NOT supported" do
      before { expect(Http::Exceptions.configuration.exceptions_to_convert).to_not include(unsupported_exception_class) }

      it "ignores other exceptions" do
        expect do
          described_class.wrap_exception do
            raise unsupported_exception_class
          end
        end.to raise_error(unsupported_exception_class)
      end
    end
  end

  describe ".check_response!" do
    it "raises exception on non-200 response" do
      expect do
        described_class.check_response!(invalid_response)
      end.to raise_error(Http::Exceptions::HttpException)
    end

    it "the raised exception contains the response" do
      begin
        described_class.check_response!(invalid_response)
      rescue Http::Exceptions::HttpException => e
        expect(e.response).to eq(invalid_response)
      end
    end

    it "returns the response on valid response" do
      expect(described_class.check_response!(valid_response)).to eq(valid_response)
    end
  end

  describe ".wrap_and_check" do
    it "raises exception on bad response" do
      expect do
        described_class.wrap_and_check do
          invalid_response
        end
      end.to raise_error(Http::Exceptions::HttpException)
    end
  end
end
