require "rails_helper"

module Api
  module Users
    RSpec.describe SessionsController, :type => :request do
      describe "#create" do
        let(:email) { "test@example.com" }
        let(:password) { "password" }
        let(:params) do
          {
            user: {
              email: email,
              password: password,
            }
          }
        end
        let!(:user) do
          create(
            :user,
            email: "test@example.com",
            password: "password",
            password_confirmation: "password",
          )
        end
        let(:post!) { post user_session_path, :params => params }

        context "invalid params" do
          context "invalid email" do
            let(:email) { "wrong@example.com" }

            it "returns an email error json response" do
              post!
              response = JSON.parse(body)

              expect(response).to eq("error" => "Email not found")
            end
          end

          context "invalid password" do
            let(:password) { "wrongpassword" }

            it "returns a password error json response" do
              post!
              response = JSON.parse(body)

              expect(response).to eq("error" => "Password invalid")
            end
          end
        end

        context "valid params" do
          before do
            allow_any_instance_of(ApplicationController)
              .to receive(:current_user).and_return(false)
          end

          it "returns the user as a json response" do
            post!
            response = JSON.parse(body)

            expect(response).to eq(
              "success" => true,
              "user" => {
                "id" => user.id,
                "email" => "test@example.com",
              }
            )
          end
        end
      end
    end
  end
end
