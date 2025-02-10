class AddRoleIdToUserOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_column :user_organisations, :role_id, :integer
    add_foreign_key :user_organisations, :roles
  end
end
