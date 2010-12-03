class AndroidAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /android_accounts/1
  # GET /android_accounts/1.xml
  def show
    @account = current_user.person.android_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /android_accounts/1/edit
  def edit
    @account = current_user.person.android_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /android_accounts/new
  def new
    @account = AndroidAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /android_accounts
  # POST /android_accounts.xml
  def create
    @account = AndroidAccount.new(params[:android_account])
    current_user.person.android_accounts << @account

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

  # PUT /android_accounts/1
  # PUT /android_accounts/1.xml
  def update
    @account = current_user.person.android_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:android_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /android_accounts
  # GET /android_accounts.xml
  def index
    @accounts = current_user.person.android_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /android_accounts/1
  # DELETE /android_accounts/1.xml
  def destroy
    @account = current_user.person.android_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

end
