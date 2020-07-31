class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  def serialize
    UserSerializer.serialize(self)
  end
end
