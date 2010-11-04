class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @url  = "http://localhost:3000/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @url  = "http://localhost:3000/"
  end
  
  protected

  def setup_email(user)
    @from        = "humanconnections11@gmail.com"
    @recipients  = "#{user.email}"
    @subject     = "[Please activate your account] "
    @sent_on     = Time.now
    @user = user
  end

end
