class AccountsController < ApplicationController
  before_filter :login_required

  TYPES = ['Facebook', 'Twitter', 'Linked_In', 'Win_Mob', 'Android', 
    'Blackberry', 'iPhone', 'Gmail', 'Hotmail', 'Yahoo', 'Email', 'Phone']

  # GET /accounts
  # GET /accounts.xml
  def index
    @allEmailAccounts = current_user.person.all_email_accounts
    @allPhoneAccounts = current_user.person.all_phone_accounts 
    @allSocialAccounts = current_user.person.all_social_accounts

    @accounts = current_user.person.accounts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accounts }
    end
  end

end
