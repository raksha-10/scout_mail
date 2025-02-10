class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :recoverable,
  :rememberable, :validatable, :jwt_authenticatable,
  jwt_revocation_strategy: self

  has_many :user_organisations
  has_many :organisations, through: :user_organisations
  has_many :roles, through: :user_organisations

  before_create :generate_jti

  def has_role?(role_name, organisation)
    user_organisations.exists?(organisation: organisation, role: Role.find_by(name: role_name))
  end
  
  def deliver_invitation
    super do |invitable|
      invitable.invitation_url = "http://localhost:3000/invitation-accept?invitation_token=#{invitable.raw_invitation_token}"
    end
  end

  private
  

  def generate_jti
    self.jti ||= SecureRandom.uuid # Or any other logic to generate the jti
  end

end

