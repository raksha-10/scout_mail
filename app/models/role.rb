class Role < ApplicationRecord
	has_many :users
	has_many :user_invitations, dependent: :destroy
	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
