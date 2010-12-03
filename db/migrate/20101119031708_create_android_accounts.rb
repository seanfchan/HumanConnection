class CreateAndroidAccounts < ActiveRecord::Migration
  def self.up
    add_column  :android_accounts, :phone_number, :string
  end

  def self.down
    remove_column :android_accounts, :phone_number
  end 
end
