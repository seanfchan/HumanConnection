require 'test_helper'
require 'user_mailer'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = Factory(:user)
  end

  test "signup_notification" do
    # Send the email, then test that it got queued
    email = UserMailer.signup_notification(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [@user.email], email.to
    assert_equal "[HumanConnections] Please activate your new account", email.subject
    assert_match /Your account has been created./, email.encoded
    assert_match /Visit this url to activate your account/, email.encoded
  end

  test "activation" do
    email = UserMailer.activation(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [@user.email], email.to
    assert_equal "[HumanConnections] Your account has been activated!", email.subject
    assert_match /your account has been activated./, email.encoded
    assert_match /http\:\/\/#{SITE_URL}\//, email.encoded
  end

end
