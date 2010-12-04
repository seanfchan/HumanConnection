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
    @account.unique_id = profile.first_name.to_s + " " + profile.last_name.to_s
    
    current_user.person.linked_in_accounts << @account

    if @account.save
      redirect_to( accounts_path, :notice => 'Account was successfully created.')
    else
      redirect_to accounts_path, :error => @account.errors 
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