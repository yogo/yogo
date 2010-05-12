class PasswordsController < ApplicationController

  before_filter :require_user
  
  def edit
    @user = current_user
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @user = current_user
    @user.attributes = params[:user]
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Password successfully updated'
        format.html
      else
        format.html { render(:action => 'edit') }
      end
    end
    
  end
    
end