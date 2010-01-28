# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: application_controller.rb
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#
class ApplicationController < ActionController::Base
  before_filter :check_local_only
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private
  
  # Checks requests to ensure they are local only
  #
  def check_local_only
    return true if Rails.env == "test"
    
    if Yogo::Settings[:local_only] && !["127.0.0.1", "0:0:0:0:0:0:0:1%0"].include?(request.env["REMOTE_ADDR"])
      # Raise a 403 exception or perhaps just redirect.
      render(:text => 'This resource is forbidden.', :status => 403) and return
    end
  end
  
end