class ModifyOrganisationsTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :organisations, :company_url, :string
    add_column :organisations, :twitter_url, :string
    add_column :organisations, :facebook_url, :string
    add_column :organisations, :tax_id, :string
  end
end
