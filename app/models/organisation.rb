class Organisation < ApplicationRecord
	has_many :users
	belongs_to :organisation_type
  
	validates :name, presence: true, uniqueness: { case_sensitive: false, message: "Organisation name must be unique" }
	validates :organisation_type, presence: true	
	validates :facebook_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true, uniqueness: { case_sensitive: false, message: "Facebook URL must be unique" }
	validates :twitter_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true, uniqueness: { case_sensitive: false, message: "Twitter URL must be unique" }
	validates :linkedin_url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true, uniqueness: { case_sensitive: false, message: "LinkedIn URL must be unique" }

  end
  