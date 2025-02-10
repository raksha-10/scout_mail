class AddUniqueIndexToOrganisationInvites < ActiveRecord::Migration[7.2]
  def change
    add_index :organisation_invites, [:user_email, :organisation_id], unique: true
  end
end
