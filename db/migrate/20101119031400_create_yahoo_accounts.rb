class CreateYahooAccounts < ActiveRecord::Migration
  def self.up
    add_column  :yahoo_accounts, :login, :string
    add_column  :yahoo_accounts, :password, :string
    add_column  :yahoo_accounts, :oauth_token, :string
    add_column  :yahoo_accounts, :oauth_secret, :string
  end

  def self.down
    remove_column :yahoo_accounts, :login
    remove_column :yahoo_accounts, :password
    remove_column :yahoo_accounts, :oauth_token
    remove_column :yahoo_accounts, :oauth_secret
  end 
end
