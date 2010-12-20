# == Schema Information
# Schema version: 20101103135942
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  email                     :string(100)
#  crypted_password          :string(64)
#  salt                      :string(64)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  state                     :string(255)     default("passive")
#  deleted_at                :datetime
#

require 'digest/sha1'
require 'digest/sha2'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles
  set_table_name 'users'

  validates :email, :presence   => true,
    :uniqueness => true,
    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
    :length     => { :within => 6..100 }

  # Relationships
  has_one  :person

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:email => email} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def enable_api!(replace=false)
    return false if !active?
    return true if (api_enabled? && !replace)
    self.update_attribute(:api_key, self.class.make_token)
  end

  def disable_api!
    self.update_attribute(:api_key, nil)
  end

  def api_enabled?
    api_key && !api_key.empty?
  end

  protected

  def make_activation_code
    return if activation_code
    self.activation_code = self.class.make_token
    self.deleted_at = nil
  end

end
