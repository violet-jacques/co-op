module Types
  class MutationType < Types::BaseObject
    field :register_user, mutation: Mutations::RegisterUserMutation
  end
end
