module Mutations
  class RegisterUserMutation < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [Types::UserErrorType], null: false

    def resolve(email:, password:, password_confirmation:)
      RegisterUser.run(
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      )
    end
  end
end
