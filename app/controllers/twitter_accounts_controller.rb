# File::      twitter_accounts_controller.rb
#
# Author::    Jon Boekenoogen (mailto:jboekeno@gmail.com)
# Copyright:: Copyright (c) 2010 <INSERT_COMPANY_NAME>

# This class is used to handle signup for Twitter accounts
# using the OAuth 1.0 protocol through the Twitter API
class TwitterAccountsController < ApplicationController

  # Require the user to be authenticated before accessing
  before_filter :login_required

  # Redirects to Twitter's website to get credentials
  # === URL
  # * GET /twitter_accounts/new
  def new
    @account = TwitterAccount.new
    request_token = @account.request_token(:oauth_callback => callback_twitter_accounts_url)
    session[:twit_rtoken] = request_token.token
    session[:twit_rsecret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_twitter_accounts_url)
  end

  # Twitter redirects here after authenticating.
  # Checks for valid parameters in request and saves TwitterAccount to DB.
  # === URL
  # * GET /twitter_accounts/callback
  def callback
    # Make sure they have required info for this url
    if params[:oauth_verifier].blank? || session[:twit_rtoken].blank? || session[:twit_rsecret].blank?
      redirect_to accounts_path
    end

    @account = TwitterAccount.new
    
    # Authorize TwitterAccount and grab needed information
    # Note: Need exception handling in case of bad oauth token
    begin
      @account.authorize(session[:twit_rtoken],
                         session[:twit_rsecret],
                         {:oauth_verifier => params[:oauth_verifier]})
      
      # We should now be authorized so try to fill in unique_id
      user_json = @account.client.verify_credentials
    rescue
      # Log and prompt them to give credentials again
      logger.debug "Unable to access TwitterApi for person #{current_user.person.id}"
      redirect_to( new_twitter_account_path, :notice => 'Twitter credentials are invalid. Please update them.')
    ensure
      # Remove stuff from the session
      session.delete(:twit_rtoken)
      session.delete(:twit_rsecret)
    end
    
    @account.unique_id = user_json.id
    @account.login = user_json.screen_name
    @account.person_id = current_user.person.id

    # User already existed so do not create another one
    existing_account = @account.existing
    @account.merge(existing_account) if existing_account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.json { render :json => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.json { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Gets all TwitterAccounts for logged in user
  # === URL
  # * GET /twitter_accounts
  # * GET /twitter_accounts.json
  # === Return 
  # All TwitterAccounts in specified format
  def index
    @accounts = current_user.person.twitter_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @accounts }
    end
  end

  # Deletes TwitterAccount
  # === URL
  # * DELETE /twitter_accounts/1
  # * DELETE /twitter_accounts/1.json
  def destroy
    @account = current_user.person.twitter_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.json { head :ok }
    end
  end

  # Gets TwitterAccount based on id
  # === URL
  # * GET /twitter_accounts/1
  # * GET /twitter_accounts/1.json
  # === Return
  # TwitterAccount in specified format
  def show
    @account = current_user.person.twitter_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end
end
