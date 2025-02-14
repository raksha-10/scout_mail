class OrganisationType < ApplicationRecord
	has_many :organisations
  validates :name, presence: true, uniqueness: true
end
