require 'spec_helper'

describe Http::Exceptions do
  let(:code)     { 200 }
  let(:response) { double(code: code, body: '') }

  class TestException < RuntimeError
  end

  describe ".wrap_exception" do
    let(:supported_exception_class)   { Http::Exceptions::Configuration::DEFAULT_EXCEPTIONS_TO_CONVERT.first }
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
    shared_examples 'invalid response' do |error_status_code|
      context "when the response code is not a 200" do
        let(:code) { error_status_code }

        it "raises exception" do
          expect do
            described_class.check_response!(response)
          end.to raise_error(Http::Exceptions::HttpException)
        end
      end

      it "the raised exception contains the response" do
        begin
          described_class.check_response!(response)
        rescue Http::Exceptions::HttpException => e
          expect(e.response).to eq(response)
        end
      end
    end

    shared_examples 'valid response' do |successful_status_code|
      context "when the response code is a 200" do
        let(:code) { successful_status_code }

        it "returns the response" do
          expect(described_class.check_response!(response)).to eq(response)
        end
      end
    end

    context "when the response code is an integer" do
      it_behaves_like 'invalid response', 400
      it_behaves_like 'valid response', 200
    end

    context "when the response code is a string" do
      it_behaves_like 'invalid response', '400'
      it_behaves_like 'valid response', '200'
    end
  end

  describe ".wrap_and_check" do
    let(:code) { 400 }

    it "raises an exception on a response with an error code" do
      expect do
        described_class.wrap_and_check do
          response
        end
      end.to raise_error(Http::Exceptions::HttpException)
    end
  end
end
