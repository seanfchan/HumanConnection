# == Schema Information
# Schema version: 20101119035757
#
# Table name: email_accounts
#
#  id             :integer         not null, primary key
#  person_id      :integer
#  last_sync_time :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  login          :string(255)
#  password       :string(255)
#

require 'model_mixins/account_properties'

class EmailAccount < ActiveRecord::Base
  include AccountProperties
  
  # Accessors
  attr_accessible :login, :password

  # Validation
  validates :login, :uniqueness => true,
                    :presence => true
end

