require "rails_helper"

module Types
  RSpec.describe MutationType do
    describe "#register_user" do
      subject(:register_user) { CoOpSchema.execute(mutation).to_h }

      let(:mutation) do
        <<~MUTATION
          mutation {
            registerUser(
              email: "test@example.com",
              password: "mypassword",
              passwordConfirmation: "mypassword"
            ) {
              user {
                id
                email
              }
              errors {
                attribute
                message
              }
            }
          }
        MUTATION
      end

      it "creates a user" do
        expect { register_user }.to change(User, :count).from(0).to(1)
      end

      it "returns the correct info" do
        expect(register_user).to eq(
          "data" => {
            "registerUser" => {
              "user" => {
                "id" => User.last.id.to_s,
                "email" => User.last.email,
              },
              "errors" => [],
            },
          }
        )
      end
    end
  end
end
