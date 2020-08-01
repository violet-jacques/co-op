require "rails_helper"

RSpec.describe RegisterUser do
  describe ".run" do
    subject do
      described_class.run(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      )
    end
    let(:email) { "test@example.com" }
    let(:password) { "password" }
    let(:password_confirmation) { "password" }

    it "creates a new user" do
      expect { subject }.to change(User, :count).from(0).to(1)
    end

    context "validation errors" do
      let(:email) { "alhiruejb" }
      let(:expected_result) do
        {
          user: nil,
          errors: [ { attribute: "email", message: "is invalid" } ],
        }
      end

      it { should eq(expected_result) }
    end

    context "email is taken" do
      let(:expected_result) do
        {
          user: nil,
          errors: [
            {
              attribute: "email",
              message: RegisterUser::EMAIL_ERROR,
            },
          ],
        }
      end

      before { create(:user, email: email) }

      it { should eq(expected_result) }
    end

    context "passwords dont match" do
      let(:password_confirmation) { "wrong" }
      let(:expected_result) do
        {
          user: nil,
          errors: [
            {
              attribute: "password",
              message: RegisterUser::PASSWORD_ERROR,
            },
          ],
        }
      end

      it { should eq(expected_result) }
    end
  end
end
