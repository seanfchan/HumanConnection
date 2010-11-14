require 'account'

class FacebookAccountsController < ApplicationController
  before_filter :login_required

  def new
    @account = FacebookAccount.new
    redirect_to @account.client.authorization.authorize_url(:redirect_uri => callback_facebook_accounts_url, 
                                                            :scope => FacebookAccount.config["perms"])
  end

  def callback
    @account = FacebookAccount.new
    @account.authorize(params[:code], :redirect_uri => callback_facebook_accounts_url)

    # We should now be authenticated so fill in email
    user_json = @account.client.selection.me.info!
    @account.login = user_json["email"]
    current_user.accounts << @account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.xml  { render :xml => @account, :status => :created, :located => @account }
      else
        format.html { redirect_to accounts_path }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

end
