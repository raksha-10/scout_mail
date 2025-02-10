class EnforceNotNullOnRoleIdInUserOrganisations < ActiveRecord::Migration[7.2]
  def change
    change_column_null :user_organisations, :role_id, false
  end
end
