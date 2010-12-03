class CreateIPhoneAccounts < ActiveRecord::Migration
  def self.up
    add_column  :iphone_accounts, :phone_number, :string
  end

  def self.down
    remove_column :iphone_accounts, :phone_number
  end 
end
