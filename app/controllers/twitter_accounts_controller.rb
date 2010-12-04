class TwitterAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = TwitterAccount.new
    request_token = @account.request_token(:oauth_callback => callback_twitter_accounts_url)
    session[:twit_rtoken] = request_token.token
    session[:twit_rsecret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_twitter_accounts_url)
  end

  def callback
    # Make sure they have required info for this url
    if params[:oauth_verifier].blank? || session[:twit_rtoken].blank? || session[:twit_rsecret].blank?
      redirect_to accounts_path
    end

    @account = TwitterAccount.new
    @account.authorize(session[:twit_rtoken],
                       session[:twit_rsecret],
                       {:oauth_verifier => params[:oauth_verifier]})

    # Remove stuff from the session
    session.delete(:twit_rtoken)
    session.delete(:twit_rsecret)

    # We should now be authorized so fill in the login name
    user_json = @account.client.verify_credentials
    @account.unique_id = user_json.id
    @account.person_id = current_user.person.id

    # User already existed so do not create another one
    existing_account = @account.existing
    @account.merge(existing_account) if existing_account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /twitter_accounts
  # GET /twitter_accounts.xml
  def index
    @accounts = current_user.person.twitter_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /twitter_accounts/1
  # DELETE /twitter_accounts/1.xml
  def destroy
    @account = current_user.person.twitter_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

  # GET /twitter_accounts/1
  # GET /twitter_accounts/1.xml
  def show
    @account = current_user.person.twitter_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end
end
