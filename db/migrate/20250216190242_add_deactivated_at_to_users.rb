class AddDeactivatedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :deactivated_at, :datetime
  end
end
