class BackfillRoleIdForUserOrganisations < ActiveRecord::Migration[7.2]
  def up
    default_role = Role.find_by(name: "Owner") # Replace "Owner" with the role you want as the default
    if default_role
      UserOrganisation.where(role_id: nil).update_all(role_id: default_role.id)
    end
  end
end
