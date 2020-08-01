require "rails_helper"

RSpec.describe Types::UserType do
  it "delegates correctly" do
    expect(described_class).to delegate_field(:id).to(User)
    expect(described_class).to delegate_field(:email).to(User)
  end
end
