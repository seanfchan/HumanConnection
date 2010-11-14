class LinkedInAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = LinkedInAccount.new
    request_token = @account.client.request_token(:oauth_callback => callback_linked_in_accounts_url)
    session['linkedin_rtoken'] = request_token.token
    session['linkedin_rsecret'] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_linked_in_accounts_url)
  end

  def callback
    @account = LinkedInAccount.new
    @account.authorize(session['linkedin_rtoken'],
                       session['linkedin_rsecret'],
                       params[:oauth_verifier])

    # Remove stuff from session that is no longer needed
    session.delete('linkedin_rtoken')
    session.delete('linkedin_rsecret')

    # We should now be authenticated so fill in email
    profile = @account.client.profile
    @account.login = profile.first_name.to_s + " " + profile.last_name.to_s
    
    current_user.accounts << @account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :located => @account }
      else
        format.html { redirect_to accounts_path }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

end
