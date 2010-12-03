class IphoneAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /iphone_accounts/1
  # GET /iphone_accounts/1.xml
  def show
    @account = current_user.person.iphone_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /iphone_accounts/1/edit
  def edit
    @account = current_user.person.iphone_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /iphone_accounts/new
  def new
    @account = IphoneAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /iphone_accounts
  # POST /iphone_accounts.xml
  def create
    @account = IphoneAccount.new(params[:iphone_account])
    current_user.person.iphone_accounts << @account

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

  # PUT /iphone_accounts/1
  # PUT /iphone_accounts/1.xml
  def update
    @account = current_user.person.iphone_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:iphone_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /iphone_accounts
  # GET /iphone_accounts.xml
  def index
    @accounts = current_user.person.iphone_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /iphone_accounts/1
  # DELETE /iphone_accounts/1.xml
  def destroy
    @account = current_user.person.iphone_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

end
