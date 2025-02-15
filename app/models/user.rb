require 'jwt'
class User < ApplicationRecord
  has_one_attached :image

  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
  :rememberable, :validatable, :jwt_authenticatable,
  jwt_revocation_strategy: self

  belongs_to :invited_by, class_name: "User", optional: true # The user who invited
  has_many :invited_users, class_name: "User", foreign_key: "invited_by_id" # Users invited by this user
  belongs_to :organisation
  belongs_to :role

  before_create :generate_jti
  # validates :password, presence: true, unless: -> { encrypted_password.blank? }
  validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true

  def generate_jwt_token
    payload = { user_id: id, exp: 24.hours.from_now.to_i, jti: jti }
    secret_key = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
    JWT.encode(payload, secret_key)
  end

  
  def generate_activation_token
    self.activation_token = SecureRandom.hex(20) # Generate a random token
  end

  
  def self.find_by_activation_token(token)
    find_by(activation_token: token)
  end  

  def generate_otp
    otp = rand(100000..999999) # Generate 6-digit OTP
    Otp.create!(user_id: id, code: otp, expires_at: 10.minutes.from_now)
    otp
  end

  def send_otp_email(otp)
    UserMailerUtils.send_otp_email(self, otp)
  end

  def send_activation_email
    UserMailerUtils.send_activation_email(self)
  end

  def invited_users_with_status
    active_invited_users = invited_users.where(deactivate: false) 
    active_invited_users.map do |user|
      user_data = user.as_json(only: [:id, :name, :email])
      user_data[:role] = user.role.name if user.role.present?
      user_data[:status] = user.invitation_accepted_at.nil? ? 'pending' : 'accepted'
      user_data
    end
  end

  private

  def generate_jti
    self.jti = SecureRandom.uuid
    JWT.encode({ user_id: id, jti: jti, exp: 24.hours.from_now.to_i}, Rails.application.credentials.secret_key_base, 'HS256')
  end

end

