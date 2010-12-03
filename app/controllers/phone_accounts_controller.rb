class PhoneAccountsController < ApplicationController
  before_filter :login_required

  # GET /phone_accounts/1
  # GET /phone_accounts/1.xml
  def show
    @account = current_user.person.all_phone_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @account }
    end
  end

  # GET /phone_accounts/new
  def new
    @account = PhoneAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @account }
    end
  end

  # POST /phone_accounts
  # POST /phone_accounts.xml
  def create
    @account = PhoneAccount.new
    begin
      new_class = params[:type].constantize
      @account = new_class.new(params[:phone_account])

      # Catch bad class names here
    rescue NameError
      flash[:error] = "Please specify an Phone Account type."
      redirect_to :action => 'new'
      return
    end

    @account.person_id = current_user.person.id

    respond_to do |format|
      if @account.save
        format.html { redirect_to( :action => 'index', :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end


  # GET /phone_accounts
  # GET /phone_accounts.xml
  def index
    @accounts = current_user.person.all_phone_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

end
