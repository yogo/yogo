# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo/users_controller.rb
# Functionality for CRUD of data within a yogo project's model
# Additionally upload and download of data via CSV is provided
#
class Yogo::UsersController < ApplicationController
  before_filter :find_parent_items, :check_project_authorization
  
  def index
    # This first way is preferred, but the second way works with the current persevere
    # @users = @groups.collect{|g| g.users }.flatten.uniq
    @users = @groups.collect{ |g| User.all(:groups => g) }.flatten.uniq

    respond_to do |format|
      format.html
    end
  end
  
  def show
    
  end
  
  def update
    
  end
  
  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @groups = @project.groups
  end
  
  def check_project_authorization
    raise AuthorizationError if !Yogo::Setting[:local_only] && (!logged_in? || !current_user.has_permission?(:edit_project,@project))
  end
  
end