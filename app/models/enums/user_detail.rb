module Enums
  module UserDetail
    extend ActiveSupport::Concern

    included do
      enum disabled: {
        prefer_not_to_answer_disabled: 0,
        is_disabled: 1,
        is_not_disabled: 2,
      }

      enum gender: {
        prefer_not_to_answer_gender: 0,
        is_non_binary: 1,
        is_female: 2,
        is_male: 3,
      }

      enum race: {
        prefer_not_to_answer_race: 0,
        black_or_african_american: 1,
        asian: 2,
        indigenous: 3,
        native_hawaiian_or_other_pacific_islander: 4,
        white: 5,
      }

      enum sexuality: {
        prefer_not_to_answer_sexuality: 0,
        is_lesbian: 1,
        is_gay: 2,
        is_bisexual: 3,
        is_other: 4,
        is_straight: 5,
      }

      enum transgender: {
        prefer_not_to_answer_transgender: 0,
        is_transgender: 1,
        is_not_transgender: 2,
      }
    end
  end
end
