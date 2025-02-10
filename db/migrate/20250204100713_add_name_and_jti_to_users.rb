class AddNameAndJtiToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :jti, :string, null: false
    add_index :users, :jti, unique: true
  end
end
