class UserDetail < ApplicationRecord
  include Enums::UserDetail
  include Validations::UserDetail

  belongs_to :user
end
