class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    add_column  :twitter_accounts, :unique_id, :string
    add_column  :twitter_accounts, :login, :string
    add_column  :twitter_accounts, :oauth_token, :string
    add_column  :twitter_accounts, :oauth_secret, :string

    # Ensure uniqueness at DB level. Also provide fast lookups
    add_index :twitter_accounts, :unique_id, :unique => true
  end

  def self.down
    remove_column :twitter_accounts, :unique_id
    remove_column :twitter_accounts, :login
    remove_column :twitter_accounts, :oauth_token
    remove_column :twitter_accounts, :oauth_secret
  
    remove_index  :twitter_accounts, :unique_id
  end 
end
