class RemoveOrganisationTypeFromOrganisations < ActiveRecord::Migration[7.2]
  def change
    remove_column :organisations, :organisation_type, :string
  end
end
