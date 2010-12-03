class CreateHotmailAccounts < ActiveRecord::Migration
  def self.up
    add_column  :hotmail_accounts, :login, :string
    add_column  :hotmail_accounts, :password, :string
    add_column  :hotmail_accounts, :oauth_token, :string
    add_column  :hotmail_accounts, :oauth_secret, :string
  end

  def self.down
    remove_column :hotmail_accounts, :login
    remove_column :hotmail_accounts, :password
    remove_column :hotmail_accounts, :oauth_token
    remove_column :hotmail_accounts, :oauth_secret
  end
end
