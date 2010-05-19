# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# File: users_controller.rb
# The Users Controller is used to create and destroy users in the yogo system.
class Yogo::UsersController < ApplicationController
  unloadable
  
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => [:show, :edit, :update]
  
  authorize_group :sysadmin
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        flash[:notice] = "Account created."
        format.html { render(:action => 'new') }
      else
        flash[:warning] = 'There were errors creating this account.'
      end
    end
  end
  
  def show
    @user = User.get(params[:id])
  end

  def edit
    @user = User.get(params[:id])
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user = User.get(params[:id])
    @user.destroy
    flash[:notice] = "User Destroyed"
    redirect_to users_path
  end
end
