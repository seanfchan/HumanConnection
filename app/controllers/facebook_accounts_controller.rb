require 'account'

class FacebookAccountsController < ApplicationController
  before_filter :login_required

  def new
    redirect_to fb_client.authorization.authorize_url(:redirect_uri => callback_facebook_accounts_url, 
                                                      :scope => @@fb_config["perms"])
  end

  def callback
    access_token = fb_client.authorization.process_callback(params[:code], 
                                                            :redirect_uri => callback_facebook_accounts_url)
    
    user_json = fb_client.selection.me.info!

    @account = FacebookAccount.new
    @account.login = user_json["email"]
    @account.oauth_token = access_token
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
