class LinkedInAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = LinkedInAccount.new
    request_token = @account.client.request_token(:oauth_callback => callback_linked_in_accounts_url)
    session[:linkedin_rtoken] = request_token.token
    session[:linkedin_rsecret] = request_token.secret
    redirect_to request_token.authorize_url(:oauth_callback => callback_linked_in_accounts_url)
  end

  def callback
    # Make sure they have required info for this url
    if params[:oauth_verifier].blank? || session[:linkedin_rtoken].blank? || session[:linkedin_rsecret].blank?
      redirect_to accounts_path
    end

    @account = LinkedInAccount.new
    @account.authorize(session[:linkedin_rtoken],
                       session[:linkedin_rsecret],
                       params[:oauth_verifier])

    # Remove stuff from session that is no longer needed
    session.delete(:linkedin_rtoken)
    session.delete(:linkedin_rsecret)

    # We should now be authenticated so fill in email
    profile = @account.client.profile(:fields => [:id])
    @account.unique_id = profile.id
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

  # GET /linked_accounts
  # GET /linked_accounts.xml
  def index
    @accounts = current_user.person.linked_in_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /linked_in_accounts/1
  # DELETE /linked_in_accounts/1.xml
  def destroy
    @account = current_user.person.linked_in_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

  # GET /linked_in_accounts/1
  # GET /linked_in_accounts/1.xml
  def show
    @account = current_user.person.linked_in_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

end
