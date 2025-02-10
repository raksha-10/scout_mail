class AddRoleToUserOrganisations < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_organisations, :role, foreign_key: true

    # Backfill existing records with the "User" role
    default_role = Role.find_or_create_by(name: "User")
    UserOrganisation.where(role_id: nil).update_all(role_id: default_role.id)

    # Now enforce NOT NULL constraint
    change_column_null :user_organisations, :role_id, false  end
end
