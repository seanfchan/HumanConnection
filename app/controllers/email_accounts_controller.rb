class EmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /email_accounts/1
  # GET /email_accounts/1.xml
  def show
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /email_accounts/1/edit
  def edit
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /email_accounts/new
  def new
    @account = EmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /email_accounts
  # POST /email_accounts.xml
  def create
    @account = EmailAccount.new(params[:email_account])
    current_user.person.email_accounts << @account

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

  # PUT /email_accounts/1
  # PUT /email_accounts/1.xml
  def update
    @account = current_user.person.email_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:email_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /email_accounts
  # GET /email_accounts.xml
  def index
    @accounts = current_user.person.email_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /email_accounts/1
  # DELETE /email_accounts/1.xml
  def destroy
    @account = current_user.person.email_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

end
