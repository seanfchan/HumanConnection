# == Schema Information
# Schema version: 20101103135942
#
# Table name: connections
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  user_id       :integer
#  connection_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# == Schema Information
# Schema version: 20101103135942
#
# Table name: connections
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  user_id       :integer
#  connection_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# == Schema Information
# Schema version: 20101031180130
#
# Table name: connections
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  user_id       :integer
#  connection_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Connection < ActiveRecord::Base
  
  # Accessors
  attr_accessible :type, :user_id, :connection_id
  
  # Relationships
  belongs_to :user, :class_name => 'User'
  belongs_to :connectee, :class_name => 'User', :foreign_key => "connection_id"
  
  validates :type, :presence => true
  validates :user_id, :presence => true
  validates :connection_id, :presence => true
end

class FamilyConnection < Connection; end
class WorkConnection < Connection; end
class FriendConnection < Connection; end
