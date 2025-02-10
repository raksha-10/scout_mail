class CreateUserOrganisations < ActiveRecord::Migration[7.2]
  def change
    create_table :user_organisations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
