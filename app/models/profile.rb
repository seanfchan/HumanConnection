# == Schema Information
# Schema version: 20101119035757
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  full_name  :string(255)
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Profile < ActiveRecord::Base

  # Accessors
  attr_accessible :full_name

  # Relationship
  belongs_to :person

  # Validation
  validates :full_name, :presence => true
  
end
