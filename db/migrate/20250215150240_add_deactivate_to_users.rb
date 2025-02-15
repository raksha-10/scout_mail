class AddDeactivateToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :deactivate, :boolean, default: false, null: false
  end
end
