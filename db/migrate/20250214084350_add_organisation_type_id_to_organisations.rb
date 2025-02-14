class AddOrganisationTypeIdToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :organisation_type_id, :integer
    add_foreign_key :organisations, :organisation_types
    add_index :organisations, :organisation_type_id
  end
end
