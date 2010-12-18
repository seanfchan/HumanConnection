class EmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /email_accounts/1
  # GET /email_accounts/1.json
  def show
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /email_accounts/1/edit
  def edit
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /email_accounts/new
  def new
    @account = EmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end
  
  # POST /email_accounts
  # POST /email_accounts.json
  def create
    @account = EmailAccount.new(params[:email_account])
    current_user.person.email_accounts << @account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.json  { render :json => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /email_accounts/1
  # PUT /email_accounts/1.json
  def update
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:email_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /email_accounts
  # GET /email_accounts.json
  def index
    @accounts = current_user.person.email_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @accounts }
    end
  end

  # DELETE /email_accounts/1
  # DELETE /email_accounts/1.json
  def destroy
    @account = current_user.person.email_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.json  { head :ok }
    end
  end

end
