class CreateWinMobAccounts < ActiveRecord::Migration
  def self.up
    add_column  :win_mob_accounts, :phone_number, :string
  end

  def self.down
    remove_column :win_mob_accounts, :phone_number
  end  
end
