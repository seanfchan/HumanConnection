# File::      api_controller.rb
#
# Author::    Jon Boekenoogen (mailto:jboekeno@gmail.com)
# Copyright:: Copyright (c) 2010 <INSERT_COMPANY_NAME>

# This class allows users to login for api calls.
class ApiController < ApplicationController

  # Require you to be logged in to remove api access
  before_filter :login_required, :only => [:destroy]

  # Authenticates using the provided email/password.
  # Returns the user authenticated.
  # === URL
  # * GET /api_login.json
  def create
    # login
    user = User.authenticate(params[:user][:email], params[:user][:password])

    respond_to do |format|
      if user
        # Create an api token for this user.
        user.enable_api!
        format.json { render :json => user }
      else
        format.json { head :unauthorized }
      end
    end
  end

  # Removes api access from the logged in user. 
  # === URL
  # * DELETE /api_logout.json
  def destroy
    # Remove the api token for this user.
    current_user.disable_api!
    respond_to do |format|
      format.json { render :json => current_user }
    end

  end

end
