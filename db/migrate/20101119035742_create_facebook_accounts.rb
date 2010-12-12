class CreateFacebookAccounts < ActiveRecord::Migration
  def self.up
    add_column  :facebook_accounts, :unique_id, :string
    add_column  :facebook_accounts, :login, :string
    add_column  :facebook_accounts, :oauth_token, :string
    
    # Ensure uniqueness at DB level. Also provide fast lookups
    add_index :facebook_accounts, :unique_id, :unique => true
  end

  def self.down
    remove_column :facebook_accounts, :unique_id
    remove_column :facebook_accounts, :login
    remove_column :facebook_accounts, :oauth_token
    
    remove_index  :facebook_accounts, :unique_id
  end 
end
