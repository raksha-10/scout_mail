class Organisation < ApplicationRecord
	# has_many :user_organisations
	has_many :users
	# has_many :user_invitations, dependent: :destroy
	validates :name, presence: true, uniqueness: { case_sensitive: false, message: "Organisation name must be unique" }
	validates :organisation_type, presence: true
	validates :company_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
	validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true
  
end
