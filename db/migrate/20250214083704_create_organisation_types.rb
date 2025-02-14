class CreateOrganisationTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :organisation_types do |t|
      t.string :name

      t.timestamps
    end
    add_index :organisation_types, :name
  end
end
