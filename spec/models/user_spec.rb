require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("email@addresse.foo").for(:email) }
    it { should_not allow_value("foo").for(:email) }
  end

  describe "#serialize" do
    let(:user) { build(:user) }

    before { allow(UserSerializer).to receive(:serialize).with(user) }

    it "passes self to the user serializer" do
      user.serialize

      expect(UserSerializer).to have_received(:serialize).with(user)
    end
  end
end
