class Organisation < ApplicationRecord
	has_many :user_organisations
	has_many :users, through: :user_organisations
	has_many :organisation_invites
	validates :name, presence: true, uniqueness: { case_sensitive: false, message: "Organisation name must be unique" }
end
