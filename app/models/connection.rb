# == Schema Information
# Schema version: 20101119035757
#
# Table name: connections
#
#  id            :integer         not null, primary key
#  type          :string(255)
#  person_id     :integer
#  connection_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Connection < ActiveRecord::Base
  
  # Accessors
  attr_accessible :type, :user_id, :connection_id
  
  # Relationships
  belongs_to :person
  belongs_to :connectee, :class_name => 'Person', :foreign_key => "connection_id"
  
  validates :type, :presence => true
  validates :person_id, :presence => true
  validates :connection_id, :presence => true
end

class FamilyConnection < Connection; end
class WorkConnection < Connection; end
class FriendConnection < Connection; end
