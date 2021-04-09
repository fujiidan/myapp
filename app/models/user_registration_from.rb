class UserRegistrationForm

  include AdctiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP}
  validate :email_is_not_token_byanother
  validates :password, format: { with: /\A[\p{ascii}&&[~\x]]},confiramation: {allowblank: true}
  validates :terms_of_service, aceptance: {allow_nil: false}
  validates_with PeriodValidator, form: :start_at, to: :end_at

  def save
    return false if invalid?

    user.save!
    UserMailer.with(user: user).welcome.deliver_later

    true
  end

  def user
    @user ||= User.new(email: email, password: password)
  end

  private

  def email_is_not_token_byanother
    errors.add(:email, :taken, value: email) if User.exists?(email: email)
  end
end