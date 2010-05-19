# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# File: permissions_controller.rb
# The Permissions Controller is used grant permissions to groups.
class Yogo::PermissionsController < ApplicationController
  unloadable
  
  require_user
  authorize_group :sysadmin
  before_filter :set_group
  
  def show
    @permissions = @group.permissions
    @controllers = Yogo::Controller.undeclaired_authorizations
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    Yogo::Permission.create(:group           => @group, 
                                 :controller_name => params[:controller_name],
                                 :action_name     => params[:action_name])

    respond_to do |format|
      format.html { redirect_to(group_permission_url(@group.id)) }
    end    
  end
  
  def destroy
    @group.permissions.get(params[:permission_id]).destroy
    
    respond_to do |format|
      format.html { redirect_to(group_permission_url(@group.id)) }
    end
  end
    
private
  def set_group
    @group = Yogo::Group.get(params[:group_id])
    # TODO: If @group.nil? throw an error
  end
end
