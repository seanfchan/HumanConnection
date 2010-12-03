class HotmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /hotmail_accounts/1
  # GET /hotmail_accounts/1.xml
  def show
    @account = current_user.person.hotmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /hotmail_accounts/1/edit
  def edit
    @account = current_user.person.hotmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /hotmail_accounts/new
  def new
    @account = HotmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /hotmail_accounts
  # POST /hotmail_accounts.xml
  def create
    @account = HotmailAccount.new(params[:hotmail_account])
    current_user.person.hotmail_accounts << @account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( :action => 'index', :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hotmail_accounts/1
  # PUT /hotmail_accounts/1.xml
  def update
    @account = current_user.person.hotmail_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:hotmail_account])
        format.html { redirect_to( :action => "index", :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /hotmail_accounts
  # GET /hotmail_accounts.xml
  def index
    @accounts = current_user.person.hotmail_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /hotmail_accounts/1
  # DELETE /hotmail_accounts/1.xml
  def destroy
    @account = current_user.person.hotmail_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.xml  { head :ok }
    end
  end

end
