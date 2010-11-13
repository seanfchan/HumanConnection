class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string   :type
      t.string   :login
      t.string   :password
      t.string   :oauth_token
      t.string   :oauth_secret
      t.string   :phone_number
      t.datetime :last_sync_time
      t.integer  :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
