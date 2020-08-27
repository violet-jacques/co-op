module Validations
  module UserDetail
    extend ActiveSupport::Concern

    included do
      validates :birthday, presence: true
      validates :disabled, presence: true
      validates :first_name, presence: true
      validates :gender, presence: true
      validates :pronouns, presence: true
      validates :race, presence: true
      validates :sexuality, presence: true
      validates :transgender, presence: true
      validates :user_id, presence: true
    end
  end
end
