module Validations
  module User
    extend ActiveSupport::Concern

    included do
      validates :email, presence: true
      validates :email, uniqueness: true
      validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
    end
  end
end
