require "rails_helper"

module Types
  RSpec.describe UserErrorType do
    subject do
      resolve_class_field(
        type: described_class,
        field: field,
        object: error,
      )
    end

    let(:error) do
      {
        "attribute" => "email",
        "message" => "too long!",
      }
    end

    describe "#attribute" do
      let(:field) { :attribute }

      it { is_expected.to eq(error["attribute"]) }
    end

    describe "#attribute" do
      let(:field) { :message }

      it { is_expected.to eq(error["message"]) }
    end
  end
end
