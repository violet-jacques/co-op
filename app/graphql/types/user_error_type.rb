module Types
  class UserErrorType < Types::BaseObject
    field :attribute, String, null: false
    field :message, [String], null: false
  end
end
