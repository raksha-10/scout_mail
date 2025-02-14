require 'jwt'
class User < ApplicationRecord
  has_one_attached :image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
  :rememberable, :validatable, :jwt_authenticatable,
  jwt_revocation_strategy: self
  
  validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
  validates :image, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
  # before_save :normalize_mobile_number
  # has_many :user_organisations
  # has_many :organisations, through: :user_organisations
  belongs_to :organisation

  belongs_to :role

  before_create :generate_jti


  def has_role?(role_name, organisation)
    user_organisations.exists?(organisation: organisation, role: Role.find_by(name: role_name))
  end

  
  def generate_jwt_token
    payload = { user_id: id, exp: 24.hours.from_now.to_i, jti: jti }
    secret_key = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
    JWT.encode(payload, secret_key)
  end

  def generate_otp
    otp = rand(100000..999999) # Generate 6-digit OTP
    Otp.create!(user_id: id, code: otp, expires_at: 10.minutes.from_now)
    otp
  end
  
  private

  # def normalize_mobile_number
  #   self.mobile = mobile.gsub(/\D/, '') # Remove non-numeric characters
  # end

  def generate_jti
    self.jti ||= SecureRandom.uuid # Or any other logic to generate the jti
  end

end

