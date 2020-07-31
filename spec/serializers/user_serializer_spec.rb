require "rails_helper"

RSpec.describe UserSerializer do
  subject(:serialized_user) { described_class.serialize(user) }
  let(:user) { build(:user) }

  let(:expected_serialization) do
    {
      id: user.id,
      email: user.email,
    }
  end

  it { should eq(expected_serialization) }
end
