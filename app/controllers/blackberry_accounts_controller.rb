class BlackberryAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /blackberry_accounts/1
  # GET /blackberry_accounts/1.xml
  def show
    @account = current_user.person.blackberry_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /blackberry_accounts/1/edit
  def edit
    @account = current_user.person.blackberry_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /blackberry_accounts/new
  def new
    @account = BlackberryAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /blackberry_accounts
  # POST /blackberry_accounts.xml
  def create
    @account = BlackberryAccount.new(params[:blackberry_account])
    current_user.person.blackberry_accounts << @account

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

  # PUT /blackberry_accounts/1
  # PUT /blackberry_accounts/1.xml
  def update
    @account = current_user.person.blackberry_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:blackberry_account])
        format.html { redirect_to( :action => "index", :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /blackberry_accounts
  # GET /blackberry_accounts.xml
  def index
    @accounts = current_user.person.blackberry_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /blackberry_accounts/1
  # DELETE /blackberry_accounts/1.xml
  def destroy
    @account = current_user.person.blackberry_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.xml  { head :ok }
    end
  end

end
