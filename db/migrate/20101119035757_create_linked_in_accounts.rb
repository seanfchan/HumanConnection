class CreateLinkedInAccounts < ActiveRecord::Migration
  def self.up
    add_column  :linked_in_accounts, :unique_id, :string
    add_column  :linked_in_accounts, :oauth_token, :string
    add_column  :linked_in_accounts, :oauth_secret, :string
    
    # Ensure uniqueness at DB level. Also provide fast lookups
    add_index :linked_in_accounts, :unique_id, :unique => true
  end

  def self.down
    remove_column :linked_in_accounts, :unique_id
    remove_column :linked_in_accounts, :oauth_token
    remove_column :linked_in_accounts, :oauth_secret
    
    remove_index  :linked_in_accounts, :unique_id
  end 
end
