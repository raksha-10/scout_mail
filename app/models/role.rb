class Role < ApplicationRecord
	has_many :user_organisations
    has_many :users, through: :user_organisations
	validates :name, presence: true, uniqueness: { case_sensitive: false }
end
