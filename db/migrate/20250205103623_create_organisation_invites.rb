class CreateOrganisationInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :organisation_invites do |t|
      t.references :organisation, null: false, foreign_key: true
      t.string :user_email
      t.string :status
      t.string :token

      t.timestamps
    end
  end
end
