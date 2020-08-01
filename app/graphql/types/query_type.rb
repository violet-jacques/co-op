module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :test, String, null: true

    def test
      "hello world!"
    end
  end
end