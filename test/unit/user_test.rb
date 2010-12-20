require 'test_helper'

class UserTest < ActiveSupport::TestCase
=begin
  # Shoulda tests (Validation, mass assignment, associations)
  # Validations
  should validate_uniqueness_of(:email)
  should validate_presence_of(:email)
  should validate_inclusion_of(:email).in_range(6..100)
  should allow_value("a@b.com").for(:email)
  should allow_value("email@gmail.com").for(:email)
  should_not allow_value("blahblah").for(:email)

  should validate_presence_of(:password)
  should validate_presence_of(:password_confirmation)

  # Associations
  should have_one(:person)

  # Mass assignment
  should_not allow_mass_assignment_of(:crypted_password)
  should_not allow_mass_assignment_of(:salt)
  should_not allow_mass_assignment_of(:activation_code)
  should_not allow_mass_assignment_of(:state)
=end
  # Comprehensive user tests
  def test_should_create_user
    assert_difference 'User.count' do
      user = Factory(:user)
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    user = pending_user
    user.reload
    assert_not_nil user.activation_code
  end

  def test_should_create_and_start_in_passive_state
    user = Factory(:user)
    user.reload
    assert user.passive?
  end

  def test_should_reset_password
    # Only active users can be authenticated
    user = active_user
    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal user, User.authenticate(user.email, 'new password')
  end

  def test_should_not_rehash_password
    # Only active users can be authenticated
    user = active_user
    user.update_attributes(:email => 'quentin2@example.com')
    assert_equal user, User.authenticate('quentin2@example.com', user.password)
  end

  def test_should_authenticate_user
    user = active_user
    assert_equal user, User.authenticate(user.email, user.password)
  end

  def test_should_set_remember_token
    user = Factory(:user)
    user.remember_me
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
  end

  def test_should_unset_remember_token
    user = Factory(:user)
    user.remember_me
    assert_not_nil user.remember_token
    user.forget_me
    assert_nil user.remember_token
  end

  def test_should_remember_me_for_one_week
    user = Factory(:user)
    before = 1.week.from_now.utc
    user.remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert user.remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    user = Factory(:user)
    time = 1.week.from_now.utc
    user.remember_me_until time
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert_equal user.remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    user = Factory(:user)
    before = 2.weeks.from_now.utc
    user.remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil user.remember_token
    assert_not_nil user.remember_token_expires_at
    assert user.remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_user
    user = Factory(:user, :password => nil, :password_confirmation => nil)
    assert user.passive?
    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    user.register!
    assert user.pending?
  end

  def test_should_suspend_user
    user = Factory(:user)
    user.suspend!
    assert user.suspended?
  end

  def test_suspended_user_should_not_authenticate
    user = Factory(:user)
    user.suspend!
    assert_not_equal user, User.authenticate(user.email, 'monkey')
  end

  def test_should_unsuspend_user_to_active_state
    user = active_user
    user.suspend!
    assert user.suspended?
    user.unsuspend!
    assert user.active?
  end

  def test_should_unsuspend_user_with_nil_activation_code_and_activated_at_to_passive_state
    user = Factory(:user)
    user.suspend!
    User.update_all :activation_code => nil, :activated_at => nil
    assert user.suspended?
    user.reload.unsuspend!
    assert user.passive?
  end

  def test_should_unsuspend_user_with_activation_code_and_nil_activated_at_to_pending_state
    user = Factory(:user)
    user.suspend!
    User.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert user.suspended?
    user.reload.unsuspend!
    assert user.pending?
  end

  def test_should_delete_user
    user = Factory(:user)
    assert_nil user.deleted_at
    user.delete!
    assert_not_nil user.deleted_at
    assert user.deleted?
  end

  def test_should_enable_api_key
    user = active_user
    assert_nil user.api_key
    user.enable_api!
    assert_not_nil user.api_key
  end

  def test_should_not_enable_api_for_inactive_user
    user = Factory(:user)
    assert_nil user.api_key
    user.enable_api!
    assert_nil user.api_key
  end

  def test_should_not_reset_api_key
    user = api_user
    assert_not_nil user.api_key
    api_key = user.api_key

    # API key should not change
    user.enable_api!
    assert_equal api_key, user.api_key
  end

  def test_should_disable_api_key
    user = api_user
    assert_not_nil user.api_key

    user.disable_api!
    assert_nil user.api_key
  end


protected
  # Helper methods.

  # Create user in active state
  def active_user
    user = pending_user
    user.activate! if user.valid?
    user
  end

  # Create user in pending state
  def pending_user
    user = Factory(:user)
    user.register! if user.valid?
    user
  end

  # Create user with api_enabled
  def api_user
    user = active_user
    user.enable_api! if user.valid?
    user
  end
end
