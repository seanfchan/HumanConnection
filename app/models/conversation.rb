# == Schema Information
# Schema version: 20101031052806
#
# Table name: conversations
#
#  id         :integer         not null, primary key
#  type       :string(255)
#  time       :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Conversation < ActiveRecord::Base

  # Accessors
  attr_accessible :type, :time
  
  # Relationships
  has_and_belongs_to_many :users
  
  # Validation
  validates :time, :presence => true
  validates :type, :presence => true
                  
end

class FacebookConversation < Conversation; end
class TwitterConversation < Conversation; end
class MyspaceConversation < Conversation; end
class LinkedInConversation < Conversation; end
class EmailConversation < Conversation; end
class PhoneConversation < Conversation; end
class SmsConversation < Conversation; end
class MmsConversation < Conversation; end
