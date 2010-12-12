class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 64
      t.column :salt,                      :string, :limit => 64
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :state,                     :string, :null => :no, :default => 'passive'
      t.column :deleted_at,                :datetime
    end
    # Ensure uniqueness at DB level. Also provide fast lookups
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
