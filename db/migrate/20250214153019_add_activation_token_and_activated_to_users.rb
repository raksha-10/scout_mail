class AddActivationTokenAndActivatedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :activation_token, :string
  end
end
