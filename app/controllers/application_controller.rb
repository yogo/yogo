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
  
  # Check for local connections before anything else
  before_filter :check_local_only 

  # include all helpers, all the time  
  helper :all 
  helper :breadcrumbs
  
  # Specify the layout for the yogo application
  layout 'application'
  
  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery 

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  protected
  
  ##
  # Create a custom error handler
  # 
  # @example Render an error if the connection is not allowed.
  #   if Yogo::Settings[:local_only] && !["127.0.0.1"].include?(request.env["REMOTE_ADDR"])
  #     render_optional_error_file(:forbidden) 
  #   end
  # 
  # @param [String] status_code the code to return
  # @return [HTML Content to browser] This returns a dynamically generated error page.
  # 
  # @api semipublic
  # 
    def render_optional_error_file(status_code)
      status = interpret_status(status_code)
      # TODO: Support I18n internationalization
      # if I18n.locale
      #   path = "/errors/#{status[0,3]}.#{I18n.locale}.html.erb"
      # else
        path = "/errors/#{status[0,3]}.html.erb"
      # end
       
      render :template => path || "/errors/unknown.html.erb", :status => status, :layout => 'error.html.erb'
    end
    
  private
  
  ##
  # Method to see if incoming connections are local (and allowed) 
  # 
  # @example If the connection is local, render the view.
  #   if check_local_only
  #     render :partial => 'dataview'
  #   end
  # 
  # @return [ String] Checks requests to ensure they are local only
  # @api private
  def check_local_only
    return true if Rails.env == "test"
    
    if Yogo::Settings[:local_only] && !["127.0.0.1", "0:0:0:0:0:0:0:1%0"].include?(request.env["REMOTE_ADDR"])
      # Raise a 403 exception or perhaps just redirect.
      render_optional_error_file(:forbidden)
    end
  end
  
end