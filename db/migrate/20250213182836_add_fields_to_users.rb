class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :mobile, :string
    add_column :users, :organisation_id, :bigint, null: false
    add_column :users, :role_id, :bigint, null: false
    add_column :users, :activated, :boolean, default: false

    add_foreign_key :users, :organisations
    add_foreign_key :users, :roles  
    add_index :users, :organisation_id
    add_index :users, :role_id
  end
end
