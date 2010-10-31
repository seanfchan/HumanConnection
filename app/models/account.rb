# == Schema Information
# Schema version: 20101031052806
#
# Table name: accounts
#
#  id             :integer         not null, primary key
#  type           :string(255)
#  login          :string(255)
#  password       :string(255)
#  oath_token     :string(255)
#  phone_number   :string(255)
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

class Account < ActiveRecord::Base

	# Accessors
	attr_accessible :type, :last_sync_time
	
	# Relationships
	belongs_to :user

	# Validation
	validates :user_id, :presence => true
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

# Social Networking Accounts
class SocialNetworkAccount < Account
	attr_accessible :oath_token
	validates :oath_token, :presence => true
end
class TwitterAccount < SocialNetworkAccount; end
class FacebookAccount < SocialNetworkAccount; end
class MyspaceAccount < SocialNetworkAccount; end
