require 'spec_helper'

describe Http::Exceptions do
  let(:invalid_response) { double(code: 400, body: '') }
  let(:valid_response) { double(code: 200) }

  class TestException < RuntimeError
  end

  describe ".wrap_exception" do
    it "raises an HttpException on supported http exceptions" do
      expect do
        described_class.wrap_exception do
          raise SocketError
        end
      end.to raise_error(Http::Exceptions::HttpException)
    end

    it "ignores other exceptions" do
      expect do
        described_class.wrap_exception do
          raise TestException
        end
      end.to raise_error(TestException)
    end
  end

  describe ".check_response!" do
    it "raises exception on non-200 response" do
      expect do
        described_class.check_response!(invalid_response)
      end.to raise_error(Http::Exceptions::HttpException)
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
