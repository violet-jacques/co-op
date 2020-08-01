require 'rails_helper'

module Mutations
  RSpec.describe RegisterUserMutation do
    subject(:create_user) do
      described_class.new(
        object: nil,
        field: nil,
        context: {}
      ).resolve(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      )
    end
    let(:email) { "test@example.com" }
    let(:password) { "mypassword" }
    let(:password_confirmation) { "mypassword" }

    before do
      allow(RegisterUser).to receive(:run).with(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      )

      create_user
    end

    it "passes info to register user command" do
      expect(RegisterUser).to have_received(:run).with(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      )
    end
  end
end
