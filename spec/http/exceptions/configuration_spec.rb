require 'spec_helper'

describe Http::Exceptions::Configuration do
  attribute_name_and_default_value_mappings = {
    exceptions_to_convert: Http::Exceptions::Configuration::DEFAULT_EXCEPTIONS_TO_CONVERT,
  }.freeze

  describe "default values" do
    subject(:model) { described_class.new }

    attribute_name_and_default_value_mappings.each do |attribute_name, default_value|
      context "for attribute #{attribute_name}" do
        subject { model.public_send(attribute_name) }

        it {should eq(default_value)}
      end
    end
  end

  describe "configurable attributes" do
    subject(:model) { described_class.new }

    attribute_name_and_default_value_mappings.each_key do |attribute_name|
      context "for attribute #{attribute_name}" do
        let(:attribute_name) { attribute_name }
        let(:new_value) { :dummy_value_for_attribute }

        subject { model.public_send(attribute_name) }

        before do
          expect(model.public_send(attribute_name)).to_not eq(new_value)
          model.public_send("#{attribute_name}=", new_value)
        end

        it {should eq(new_value)}
      end
    end
  end
end
