class YahooAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /yahoo_accounts/1
  # GET /yahoo_accounts/1.xml
  def show
    @account = current_user.person.yahoo_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /yahoo_accounts/1/edit
  def edit
    @account = current_user.person.yahoo_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /yahoo_accounts/new
  def new
    @account = YahooAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /yahoo_accounts
  # POST /yahoo_accounts.xml
  def create
    @account = YahooAccount.new(params[:yahoo_account])
    current_user.person.yahoo_accounts << @account

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

  # PUT /yahoo_accounts/1
  # PUT /yahoo_accounts/1.xml
  def update
    @account = current_user.person.yahoo_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:yahoo_account])
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /yahoo_accounts
  # GET /yahoo_accounts.xml
  def index
    @accounts = current_user.person.yahoo_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /yahoo_accounts/1
  # DELETE /yahoo_accounts/1.xml
  def destroy
    @account = current_user.person.yahoo_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.xml  { head :ok }
    end
  end

end
