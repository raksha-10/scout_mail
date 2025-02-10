class CreateOrganisations < ActiveRecord::Migration[7.2]
  def change
    create_table :organisations do |t|
      t.string :name

      t.timestamps
    end
  end
end
