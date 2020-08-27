class User < ApplicationRecord
  include Validations::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :user_detail
end
