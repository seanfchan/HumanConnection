class PhoneAccountsController < ApplicationController
  before_filter :login_required

  # GET /phone_accounts/1
  # GET /phone_accounts/1.json
  def show
    @account = current_user.person.phone_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /phone_accounts/1/edit
  def edit
    @account = current_user.person.phone_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @account }
    end
  end

  # GET /phone_accounts/new
  def new
    @account = PhoneAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @account }
    end
  end

  # POST /phone_accounts
  # POST /phone_accounts.json
  def create
    @account = PhoneAccount.new(params[:phone_account])
    current_user.person.phone_accounts << @account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.json  { render :json => @account, :status => :created, :location => @account }
      else
        format.html { render :action => 'new' }
        format.json  { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /phone_accounts
  # GET /phone_accounts.json
  def index
    @accounts = current_user.person.phone_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @accounts }
    end
  end

  # DELETE /phone_accounts/1
  # DELETE /phone_accounts/1.json
  def destroy
    @account = current_user.person.phone_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.json  { head :ok }
    end
  end

end
