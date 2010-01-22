# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Yogo::AuthenticatedSystem
  include Yogo::AuthorizationSystem
  
  before_filter :check_local_only
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private
  
  def check_local_only
    return true if Rails.env == "test"
    
    if Yogo::Settings[:local_only] && !request.env["REMOTE_ADDR"].match("127.0.0.1")
      # Raise a 403 exception or perhaps just redirect.
      render(:text => 'This resource is forbidden.', :status => 403) and return
    end
  end
  
end