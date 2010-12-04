class FacebookAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = FacebookAccount.new
    redirect_to @account.client.authorization.authorize_url(:redirect_uri => callback_facebook_accounts_url, 
                                                            :scope => FacebookAccount.config["perms"])
  end

  def callback
    # Make sure they include the required params
    if params[:code].blank?
      redirect_to accounts_path  
    end

    @account = FacebookAccount.new
    @account.authorize(params[:code], :redirect_uri => callback_facebook_accounts_url)

    # We should now be authenticated so fill in 
    user_json = @account.client.selection.me.info!
    @account.unique_id = user_json["id"]
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

  # GET /facebook_accounts
  # GET /facebook_accounts.xml
  def index
    @accounts = current_user.person.facebook_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /facebook_accounts/1
  # DELETE /facebook_accounts/1.xml
  def destroy
    @account = current_user.person.facebook_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

  # GET /facebook_accounts/1
  # GET /facebook_accounts/1.xml
  def show
    @account = current_user.person.facebook_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

end
