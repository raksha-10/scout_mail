class FixUserOrganisationRoles < ActiveRecord::Migration[7.2]
  def up
    owner_role = Role.find_or_create_by(name: "Owner")
    user_role = Role.find_by(name: "User")

    # Reassign wrongly assigned "User" roles to "Owner"
    if user_role && owner_role
      UserOrganisation.where(role_id: user_role.id).update_all(role_id: owner_role.id)
    end
  end

  def down
    # Revert back to "User" role if needed
    owner_role = Role.find_by(name: "Owner")
    user_role = Role.find_by(name: "User")

    if owner_role && user_role
      UserOrganisation.where(role_id: owner_role.id).update_all(role_id: user_role.id)
    end
  end
end
