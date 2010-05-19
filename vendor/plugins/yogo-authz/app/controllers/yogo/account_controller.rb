# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# File: users_controller.rb
# The Users Controller is used to create and destroy users in the yogo system.
class Yogo::AccountController < ApplicationController
  unloadable
  
  # require_no_user, :only => [:new, :create]
  # require_user, :only => [:show, :edit, :update]
  
  require_user
  
  def show
    @user = current_user
  end

  # I don't think we should do this here.
  # But I'm leaving this skeletion in for now.  
  # def new
  #   @user = User.new
  # end
  
  # def create
  #   @user = User.new(params[:user])
  #   if @user.save
  #     flash[:notice] = "Account registered!"
  #     redirect_back_or_default account_url
  #   else
  #     render :action => :new
  #   end
  # end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user = current_user
    @user.destroy
    flash[:notice] = "User Destroyed"
    redirect_to users_path
  end
end
