# == Schema Information
# Schema version: 20101119035757
#
# Table name: people
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Person < ActiveRecord::Base

  # Account relationships
  has_many :gmail_accounts
  has_many :hotmail_accounts
  has_many :email_accounts
  has_many :yahoo_accounts
  
  has_many :phone_accounts
  has_many :iphone_accounts
  has_many :android_accounts
  has_many :win_mob_accounts
  has_many :blackberry_accounts

  has_many :linked_in_accounts
  has_many :twitter_accounts
  has_many :facebook_accounts
  
  has_one  :profile

  has_many :conversations
  has_many :connections
  has_many :connectees, :through => :connections

  def accounts(force = false)
    if force || !@accounts
      @accounts = all_email_accounts + all_phone_accounts 
        + all_social_accounts
    end
    @accounts
  end

  def all_email_accounts(force = false)
    if force || !@email_accounts
      @email_accounts = email_accounts + yahoo_accounts + 
        gmail_accounts + hotmail_accounts
    end
    @email_accounts
  end

  def all_phone_accounts(force = false)
    if force || !@phone_accounts
      @phone_accounts = phone_accounts + android_accounts + 
        iphone_accounts + blackberry_accounts + win_mob_accounts
    end
    @phone_accounts
  end

  def all_social_accounts(force = false)
    if force || !@social_accounts
      @social_accounts = facebook_accounts + twitter_accounts + 
        linked_in_accounts
    end
    @social_accounts
  end
end
