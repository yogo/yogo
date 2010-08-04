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
  
  ##
  # List all users in a project
  #
  # @example
  #   get /project/:project_id/users
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def index
    # Just get all the users. This should work for now
    @users = User.all

    respond_to do |format|
      format.html
    end
  end
  
  ##
  # Create a new user in the system
  #
  # @example
  #   get /project/:project_id/users/new
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def new
    @user = User.new
    
    respond_to do |format|
      format.html
    end
  end
  
  ##
  # Creates a new  user in the system
  #
  # @example
  #   post /project/:project_id/users/ {:user => {:login => 'name', :password => 'pass', :password_confirmation => 'pass'}
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def create
    params[:user].delete(:admin)
    params[:user].delete(:create_projects)
    
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.valid?
        @user.save
        flash[:notice] = "User created"
        format.html { redirect_to(project_users_url(@project)) }
      else
        flash[:error] = "User was unable to be created"
        format.html { render(:action => 'new') }
      end
    end
  end
  
  ##
  # Creates a new  user in the system
  #
  # @example
  #   post /users/ {:user => {:login => 'name', :password => 'pass', :password_confirmation => 'pass'}
  #
  # @return [HTML]
  #  html response
  #
  # @todo Make this less painful with some ajax probably
  #
  # @api public
  def update_user_roles
    @roles.each{|g| g.users.clear }

    params[:roles].each_pair do |role_id, user_ids|
      @roles.get(role_id).users = User.all(:id => user_ids)
    end

    if @roles.save
      flash[:notice] = "Roles updated for the users"
    else
      flash[:error] = "Something strange happened. I'm sorry, the Roles weren't updated with the users."
    end

    respond_to do |format|
      format.html { redirect_to(project_users_url(@project)) }
    end
  end
  
  private
  
  ##
  # Finds the parent items for the controller
  # 
  # @example
  #   Don't use this directly
  # @return [nil] Sets variables, doesn't return usefull information
  # @api private
  def find_parent_items
    @project = Yogo::Project.get(params[:project_id])
    @roles = @project.roles
  end

  ##
  # Checks authorization for the controller
  # 
  # @example
  #   Don't use this directly
  # @return [nil] Raises an error
  # @api private
  def check_project_authorization
    raise AuthorizationError if !Yogo::Setting[:local_only] && (!logged_in? || !current_user.has_permission?(:edit_project,@project))
  end
  
end