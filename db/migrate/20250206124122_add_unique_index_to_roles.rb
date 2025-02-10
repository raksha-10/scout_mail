class AddUniqueIndexToRoles < ActiveRecord::Migration[7.2]
  def change
    add_index :roles, "lower(name)", unique: true
  end
end
