require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should allow_value("email@addresse.foo").for(:email) }
    it { should_not allow_value("foo").for(:email) }
  end
end