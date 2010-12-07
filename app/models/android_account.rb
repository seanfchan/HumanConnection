# == Schema Information
# Schema version: 20101119035757
#
# Table name: android_accounts
#
#  id             :integer         not null, primary key
#  account_type   :string(255)     default("AndroidAccount")
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  phone_number   :string(255)
#

require 'model_mixins/account_properties'

class AndroidAccount < ActiveRecord::Base
  include AccountProperties

  # Accessors
  attr_accessible :phone_number
  
  # Validation
  validates :phone_number, :presence => true

end

