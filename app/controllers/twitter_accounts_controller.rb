require 'account'

class TwitterAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = TwitterAccount.new
    request_token = @account.request_token(:oauth_callback => callback_twitter_accounts_url)
    session['twit_rtoken'] = request_token.token
    session['twit_rsecret'] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_twitter_accounts_url)
  end

  def callback
    @account = TwitterAccount.new

    access_token = @account.authorize(session['twit_rtoken'],
                                      session['twit_rsecret'],
                                      {:oauth_verifier => params[:oauth_verifier]})

    # Remove stuff from the session
    session.delete('twit_rtoken')
    session.delete('twit_rsecret')

    # We should now be authorized so fill in the login name
    user_json = @account.client.verify_credentials
    @account.login = user_json.screen_name

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
