class EmailAccountsController < ApplicationController
  before_filter :login_required
  
  # GET /email_accounts/1
  # GET /email_accounts/1.xml
  def show
    tmpAccount = EmailAccount.new(:id => params[:id])
    idx = current_user.person.all_email_accounts.index(tmpAccount)
    
    if idx
      @account = current_user.person.all_email_accounts[idx]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /email_accounts/1/edit
  def edit
    tmpAccount = EmailAccount.new(:id => params[:id])
    idx = current_user.person.all_email_accounts.index(tmpAccount)
    
    if idx
      @account = current_user.person.all_email_accounts[idx]
    end

    if !@account
      redirect_to(:action => "index", :error => "We could not find your account.")
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
    @account = EmailAccount.new
    begin
      new_class = params[:type].constantize
      @account = new_class.new(params[:email_account])

    # Catch bad class names here
    rescue NameError
      flash[:error] = "Please specify an Email Account type."
      redirect_to :action => 'new'
      return
    end

    @account.person_id = current_user.person.id

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

  # PUT /email_accounts/1
  # PUT /email_accounts/1.xml
  def update
    tmpAccount = EmailAccount.new(:id => params[:id])
    idx = current_user.person.all_email_accounts.index(tmpAccount)
    
    if idx
      @account = current_user.person.all_email_accounts[idx]
    end

    respond_to do |format|
      if @account.update_attributes(params[:email_account])
        format.html { redirect_to( :action => "index", :notice => 'Account was successfully updated.') }
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
    @accounts = current_user.person.all_email_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

  # DELETE /email_accounts/1
  # DELETE /email_accounts/1.xml
  def destroy
    @account = current_user.person.all_email_accounts.collect { |account|
      account if account.person_id == current_user.person.id
    }.first
    @account.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index" }
      format.xml  { head :ok }
    end
  end

end
