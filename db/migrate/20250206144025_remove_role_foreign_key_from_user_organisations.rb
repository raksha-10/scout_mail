class RemoveRoleForeignKeyFromUserOrganisations < ActiveRecord::Migration[7.2]
  def change
    remove_column :user_organisations, :role_id, :integer
  end
end
