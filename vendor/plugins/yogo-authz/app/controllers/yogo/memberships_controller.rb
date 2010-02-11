# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# File: memberships_controller.rb
# The Memberships Controller is used to manage what groups a user belongs to.
class Yogo::MembershipsController < ApplicationController
  unloadable
  
  require_user
  authorize_group :sysadmin
  
  before_filter :set_user
  
  def show
    @user_memberships = @user.memberships
    @groups = Yogo::Group.all - @user.groups
  end
  
  def create
    Yogo::Membership.create(:user => @user,
                      :group => Yogo::Group.get(params[:group_id]))
    
    respond_to do |format|
      format.html { redirect_to(user_membership_path(@user.id)) }
    end
  end
  
  def destroy
    @user.memberships.get(params[:membership_id]).destroy
    
    respond_to do |format|
      format.html { redirect_to(user_membership_path(@user.id)) }
    end
  end
  
  private
  
  def set_user
    @user = User.get(params[:user_id])
    #TODO: If @user.nil? throw an error
  end
end
