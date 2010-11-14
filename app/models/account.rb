# == Schema Information
# Schema version: 20101103135942
#
# Table name: accounts
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  login          :string(255)
#  password       :string(255)
#  oauth_token    :string(255)
#  oauth_secret   :string(255)
#  phone_number   :string(255)
#  last_sync_time :datetime
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Account < ActiveRecord::Base

  protected

  # Accessors
  attr_accessible :type, :last_sync_time, :user_id

  # Relationships
  belongs_to :user

  # Validation
  # Don't allow duplicate logins for same account type
  validates :user_id, :presence => true,
    :uniqueness => {:scope => [:type, :login]}
  validates :type, :presence => true

end

# Email Accounts
class EmailAccount < Account
  attr_accessible :login, :password
  validates :login,    :presence => true
  validates :password, :presence => true
end
class GmailAccount < Account; end
class HotmailAccount < Account; end
class YahooAccount < Account; end

# Phone Accounts
class PhoneAccount < Account
  attr_accessible :phone_number
  validates :phone_number, :presence => true
end
class IPhoneAccount < PhoneAccount; end
class AndroidAccount < PhoneAccount; end
class WinMobAccount < PhoneAccount; end
class BlackBerryAccount < PhoneAccount; end
