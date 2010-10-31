# == Schema Information
# Schema version: 20101031200251
#
# Table name: users
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

	# Accessors
	attr_accessible :email, :password
	
	# Relationships
	has_one  :profile
	has_many :accounts
	has_many :connections
	has_many :connectees, :through => :connections
	has_and_belongs_to_many :conversations
	
	# Validation
	validates :email, :presence => true,
	                  :uniqueness => { :case_sensitive => false }
	validates :password, :presence => true,
	                     :length   => { :minimum => 6 }
end
