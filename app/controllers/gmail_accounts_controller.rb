class GmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /gmail_accounts/1
  # GET /gmail_accounts/1.json
  def show
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /gmail_accounts/1/edit
  def edit
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /gmail_accounts/new
  def new
    @account = GmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end
  
  # POST /gmail_accounts
  # POST /gmail_accounts.json
  def create
    @account = GmailAccount.new(params[:gmail_account])
    current_user.person.gmail_accounts << @account

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

  # PUT /gmail_accounts/1
  # PUT /gmail_accounts/1.json
  def update
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:gmail_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.json  { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /gmail_accounts
  # GET /gmail_accounts.json
  def index
    @accounts = current_user.person.gmail_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @accounts }
    end
  end

  # DELETE /gmail_accounts/1
  # DELETE /gmail_accounts/1.json
  def destroy
    @account = current_user.person.gmail_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.json  { head :ok }
    end
  end

end
