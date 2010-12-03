class CreateGmailAccounts < ActiveRecord::Migration
  def self.up
    add_column  :gmail_accounts, :login, :string
    add_column  :gmail_accounts, :password, :string
    add_column  :gmail_accounts, :oauth_token, :string
    add_column  :gmail_accounts, :oauth_secret, :string
  end

  def self.down
    remove_column :gmail_accounts, :login
    remove_column :gmail_accounts, :password
    remove_column :gmail_accounts, :oauth_token
    remove_column :gmail_accounts, :oauth_secret
  end
end
