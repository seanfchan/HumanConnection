# == Schema Information
# Schema version: 20101031200251
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  full_name  :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base

	# Accessors
 	attr_accessible :full_name

	# Relationship
	belongs_to :user

	# Validation
    validates :full_name, :presence => true
	
end
