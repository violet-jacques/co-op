require "rails_helper"

RSpec.describe UserDetail do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:race) }
    it { should validate_presence_of(:transgender) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:disabled) }
    it { should validate_presence_of(:sexuality) }
    it { should validate_presence_of(:birthday) }
    it { should validate_presence_of(:user_id) }
  end

  describe "enums" do
    it { should define_enum_for(:transgender).with_values(
      prefer_not_to_answer_transgender: 0,
      is_transgender: 1,
      is_not_transgender: 2,
    )}

    it { should define_enum_for(:disabled).with_values(
      prefer_not_to_answer_disabled: 0,
      is_disabled: 1,
      is_not_disabled: 2,
    )}

    it { should define_enum_for(:gender).with_values(
      prefer_not_to_answer_gender: 0,
      is_non_binary: 1,
      is_female: 2,
      is_male: 3,
    )}

    it { should define_enum_for(:sexuality).with_values(
      prefer_not_to_answer_sexuality: 0,
      is_lesbian: 1,
      is_gay: 2,
      is_bisexual: 3,
      is_other: 4,
      is_straight: 5,
    )}

    it { should define_enum_for(:race).with_values(
      prefer_not_to_answer_race: 0,
      black_or_african_american: 1,
      asian: 2,
      indigenous: 3,
      native_hawaiian_or_other_pacific_islander: 4,
      white: 5,
    )}
  end
end
