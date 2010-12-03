class CreatePhoneAccounts < ActiveRecord::Migration
  def self.up
    add_column  :phone_accounts, :phone_number, :string
  end

  def self.down
    remove_column :phone_accounts, :phone_number
  end
end
