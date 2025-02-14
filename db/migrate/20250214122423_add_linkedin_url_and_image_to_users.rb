class AddLinkedinUrlAndImageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :linkedin_url, :string
    add_column :users, :image, :string
  end
end
