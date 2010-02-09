# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# File: user_sessions_controller.rb
# The UserSessions Controller is used for logging people in and out of the system.
class Yogo::UserSessionsController < ApplicationController
  unloadable
  
  # before_filter :require_no_user, :only => [:new, :create]
  # before_filter :require_user, :only => :destroy
  
  require_user    :for => :destroy
  require_no_user :for => [:new, :create]
  # authorize_group :default
  
  def new
    @user_session = Yogo::UserSession.new
  end
  
  def create
    @user_session = Yogo::UserSession.new(params[:yogo_user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
  
end
