# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Yogo::AuthenticatedSystem
  include Yogo::AuthorizationSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :get_projects
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  def get_projects
    @projects = Project.all
  end
end
