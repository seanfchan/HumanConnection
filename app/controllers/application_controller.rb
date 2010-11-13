class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery

  protected

end
