class CreateEmailAccounts < ActiveRecord::Migration
  def self.up
    add_column  :email_accounts, :login, :string
    add_column  :email_accounts, :password, :string
  end

  def self.down
    remove_column :email_accounts, :login
    remove_column :email_accounts, :password
  end  
end
