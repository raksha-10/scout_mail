class DropOrganisationInvites < ActiveRecord::Migration[7.2]
  def change
    drop_table :organisation_invites, if_exists: true
  end
end
