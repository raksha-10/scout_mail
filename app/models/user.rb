require 'jwt'
class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
  :rememberable, :validatable, :jwt_authenticatable,
  jwt_revocation_strategy: self

  # has_many :user_organisations
  # has_many :organisations, through: :user_organisations
  has_many :roles
  # has_many :user_invitations, dependent: :destroy  # All invitations sent to this user
  # has_many :sent_invitations, class_name: "UserInvitation", foreign_key: "invited_by_id"

  before_create :generate_jti

  def has_role?(role_name, organisation)
    user_organisations.exists?(organisation: organisation, role: Role.find_by(name: role_name))
  end

  
  def generate_jwt_token
    payload = { user_id: id, exp: 24.hours.from_now.to_i }
    secret_key = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']
    JWT.encode(payload, secret_key)
  end

  
  
  private


  def generate_jti
    self.jti ||= SecureRandom.uuid # Or any other logic to generate the jti
  end

end

