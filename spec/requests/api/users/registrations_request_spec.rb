require "rails_helper"

module Api
  module Users
    RSpec.describe RegistrationsController, :type => :request do
      describe "#create" do
        let(:email) { "test@example.com" }
        let(:password) { "password" }
        let(:password_confirmation) { "password" }
        let(:params) do
          {
            user: {
              email: email,
              password: password,
              password_confirmation: password_confirmation,
            }
          }
        end
        let(:post!) { post user_registration_path, :params => params }

        context "invalid params" do
          context "email in use" do
            let!(:user) do
              create(
                :user,
                email: "test@example.com",
                password: "password",
                password_confirmation: "password",
              )
            end

            it "returns an email error json response" do
              post!
              response = JSON.parse(body)

              expect(response).to eq("error" => "Email already in use")
            end
          end

          context "passwords dont match" do
            let(:password) { "whatsup" }

            it "returns a password error json response" do
              post!
              response = JSON.parse(body)

              expect(response).to eq("error" => "Passwords dont match")
            end
          end
        end

        context "valid params" do
          it "creates the user" do
            expect do
              post!
            end.to change { User.count }.by(1)
          end

          it "returns the user as a json response" do
            post!

            response = JSON.parse(body)

            expect(response).to eq(
              "success" => true,
              "user" => {
                "id" => User.last.id,
                "email" => "test@example.com",
              }
            )
          end
        end
      end
    end
  end
end
