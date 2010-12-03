class CreateLinkedInAccounts < ActiveRecord::Migration
  def self.up
    add_column  :linked_in_accounts, :unique_id, :string
    add_column  :linked_in_accounts, :oauth_token, :string
    add_column  :linked_in_accounts, :oauth_secret, :string
  end

  def self.down
    remove_column :linked_in_accounts, :unique_id
    remove_column :linked_in_accounts, :oauth_token
    remove_column :linked_in_accounts, :oauth_secret
  end 
end
