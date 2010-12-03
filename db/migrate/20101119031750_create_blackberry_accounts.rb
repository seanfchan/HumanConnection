class CreateBlackberryAccounts < ActiveRecord::Migration
  def self.up
    add_column  :blackberry_accounts, :phone_number, :string
  end

  def self.down
    remove_column :blackberry_accounts, :phone_number
  end  
end
