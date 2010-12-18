# File:: facebook_accounts_controller.rb
#
# Author::  Jon Boekenoogen (mailto: jboekeno@gmail.com)
# Commented by::  Madiha Mubin
# Copyright::  Copyright (c) 2010 <INSERT_COMPANY_NAME>

# This class is used to handle signup for Facebook accounts
# using OAuth protocol through the FBGraph API
class FacebookAccountsController < ApplicationController
  
  # Require the user to be authenticated before accessing
  before_filter :login_required

  # Redirects to Facebook's website to get credentials
  # === URL
  # * GET /facebook_accounts/new
  def new
    @account = FacebookAccount.new
    redirect_to @account.client.authorization.authorize_url(:redirect_uri => callback_facebook_accounts_url, 
                                                            :scope => FacebookAccount.config["perms"])
  end

  # Facebook redirected here post-authentication.
  # Checks for valid parameters in request. Saved FacebookAccount to database.
  # === URL
  # * GET /facebook_account/callback
  def callback
    # Make sure they include the required params
    if params[:code].blank?
      redirect_to accounts_path  
    end

    @account = FacebookAccount.new
    @account.authorize(params[:code], :redirect_uri => callback_facebook_accounts_url)

    # We should now be authenticated so fill in 
    # Wrap in exception handling in case we do not have access
    begin
      # authorized to fill in the unique id and other credentials.
      user_json = @account.client.selection.me.info!
    rescue
      # Log and prompt them to give credentials again
      logger.debug "Unable to access FacebookApi for person #{current_user.person.id}"
      redirect_to( new_facebook_account_path, :notice => 'Facebook credentials are invalid. Please update them.')
    end
   
    @account.unique_id = user_json[:id]
    @account.login = user_json[:email]
    @account.person_id = current_user.person.id

    # User already existed so do not create another one
    existing_account = @account.existing
    # TODO @Jon: Implement a full person-2-person merge. Not just accounts
    @account.merge(existing_account) if existing_account

    respond_to do |format|
      if @account.save
        format.html { redirect_to( accounts_path, :notice => 'Account was successfully created.') }
        format.json { render :json => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Gets all FacebookAccounts for logged in user
  # === URL
  # * GET /facebook_accounts
  # * GET /facebook_accounts.json
  # === Return
  # All FacebookAccounts in specified format
  def index
    @accounts = current_user.person.facebook_accounts

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @accounts }
    end
  end

  # Deleted the FacebookAccount
  # === URL
  # DELETE /facebook_accounts/1
  # DELETE /facebook_accounts/1.json
  def destroy
    @account = current_user.person.facebook_accounts.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_path }
      format.json  { head :ok }
    end
  end

  # Gets FacebookAccount based on id
  # === URL
  # GET /facebook_accounts/1
  # GET /facebook_accounts/1.json
  # === Return 
  # FacebookAccount in specified format
  def show
    @account = current_user.person.facebook_accounts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @account }
    end
  end

end
