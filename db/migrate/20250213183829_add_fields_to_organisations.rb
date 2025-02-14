class AddFieldsToOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :organisations, :organisation_type, :string
    add_column :organisations, :mobile, :string
    add_column :organisations, :location, :string
    add_column :organisations, :company_url, :string
    add_column :organisations, :linkedin_url, :string
    add_column :organisations, :email, :string, null: false, default: ""

    add_index :organisations, :organisation_type
    add_index :organisations, :mobile
    add_index :organisations, :company_url, unique: true
    add_index :organisations, :email, unique: true 

  end
end