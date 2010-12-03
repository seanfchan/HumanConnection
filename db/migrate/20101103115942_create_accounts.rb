# Create common properties in all account tables.
class CreateAccounts < ActiveRecord::Migration

  @@accounts = [:gmail_accounts, :hotmail_accounts, :yahoo_accounts, :email_accounts,
    :iphone_accounts, :android_accounts, :win_mob_accounts, :blackberry_accounts, :phone_accounts,
    :facebook_accounts, :twitter_accounts, :linked_in_accounts]

  def self.up
    @@accounts.each do |account|
      create_table account do |t|
        t.string   :account_type, :default => account.to_s.camelcase.chop
        t.integer  :person_id
        t.datetime :last_sync_time
        t.timestamps
      end
    end
  end

    def self.down
      @@accounts.each do |account|
        drop_table account
      end
    end
  end
