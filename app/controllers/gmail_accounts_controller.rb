class GmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /gmail_accounts/1
  # GET /gmail_accounts/1.xml
  def show
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /gmail_accounts/1/edit
  def edit
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /gmail_accounts/new
  def new
    @account = GmailAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end
  
  # POST /gmail_accounts
  # POST /gmail_accounts.xml
  def create
    @account = GmailAccount.new(params[:gmail_account])
    current_user.person.gmail_accounts << @account

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

  # PUT /gmail_accounts/1
  # PUT /gmail_accounts/1.xml
  def update
    @account = current_user.person.gmail_accounts.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:gmail_account])
        format.html { redirect_to( :action => "index", :notice => 'Account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /gmail_accounts
  # GET /gmail_accounts.xml
  def index
    @accounts = current_user.person.gmail_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /gmail_accounts/1
  # DELETE /gmail_accounts/1.xml
  def destroy
    @account = current_user.person.gmail_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.xml  { head :ok }
    end
  end

end
