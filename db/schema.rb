# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101119035757) do

  create_table "android_accounts", :force => true do |t|
    t.string   "account_type",   :default => "AndroidAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  create_table "blackberry_accounts", :force => true do |t|
    t.string   "account_type",   :default => "BlackberryAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  create_table "connections", :force => true do |t|
    t.string   "type"
    t.integer  "person_id"
    t.integer  "connection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.string   "type"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations_users", :id => false, :force => true do |t|
    t.integer "person_id"
    t.integer "conversation_id"
  end

  create_table "email_accounts", :force => true do |t|
    t.string   "account_type",   :default => "EmailAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "password"
  end

  create_table "facebook_accounts", :force => true do |t|
    t.string   "account_type",   :default => "FacebookAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_id"
    t.string   "oauth_token"
  end

  create_table "gmail_accounts", :force => true do |t|
    t.string   "account_type",   :default => "GmailAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "password"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

  create_table "hotmail_accounts", :force => true do |t|
    t.string   "account_type",   :default => "HotmailAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "password"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

  create_table "iphone_accounts", :force => true do |t|
    t.string   "account_type",   :default => "IphoneAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  create_table "linked_in_accounts", :force => true do |t|
    t.string   "account_type",   :default => "LinkedInAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

  create_table "people", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_accounts", :force => true do |t|
    t.string   "account_type",   :default => "PhoneAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  create_table "profiles", :force => true do |t|
    t.string   "full_name"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_accounts", :force => true do |t|
    t.string   "account_type",   :default => "TwitterAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 64
    t.string   "salt",                      :limit => 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "win_mob_accounts", :force => true do |t|
    t.string   "account_type",   :default => "WinMobAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
  end

  create_table "yahoo_accounts", :force => true do |t|
    t.string   "account_type",   :default => "YahooAccounts"
    t.integer  "person_id"
    t.datetime "last_sync_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "password"
    t.string   "oauth_token"
    t.string   "oauth_secret"
  end

end
