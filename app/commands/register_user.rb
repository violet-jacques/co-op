class RegisterUser
  EMAIL_ERROR = "Email already in use".freeze
  PASSWORD_ERROR = "Passwords dont match".freeze

  def self.run(email:, password:, password_confirmation:)
    new(email, password, password_confirmation).run
  end

  def initialize(email, password, password_confirmation)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end

  def run
    if User.find_for_database_authentication(email: email).present?
      response(errors: [error_response("email", EMAIL_ERROR)])
    elsif password != password_confirmation
      response(errors: [error_response("password", PASSWORD_ERROR)])
    elsif user.save
      response(user: user)
    else
      response(errors: error_messages)
    end
  end

  private

  attr_reader :email, :password, :password_confirmation

  def user
    @user ||= User.new(email: email, password: password)
  end

  def response(user: nil, errors: [])
    { user: user, errors: errors }
  end

  def error_response(attribute, message)
    { attribute: attribute, message: message }
  end

  def error_messages
    user
      .errors
      .messages
      .map do |(error, messages)|
        { attribute: error.to_s, message: messages.uniq.join(', ') }
      end
  end
end
