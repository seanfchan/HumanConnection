class CreateFacebookAccounts < ActiveRecord::Migration
  def self.up
    add_column  :facebook_accounts, :unique_id, :string
    add_column  :facebook_accounts, :oauth_token, :string
  end

  def self.down
    remove_column :facebook_accounts, :unique_id
    remove_column :facebook_accounts, :oauth_token
  end 
end
