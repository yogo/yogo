class PasswordsController < ApplicationController

  before_filter :require_user
  
  ##
  # Gets password edit form for a user
  # 
  # @example 
  #   get /passwords/edit
  # 
  # @return [Page] the rendered webpage for editing a password
  # 
  # @author lamb
  # 
  # @api public
  def edit
    @user = current_user
    
    respond_to do |format|
      format.html
    end
  end
  
  ##
  # Updates the password for the current user
  # 
  # @example 
  #   post /passwords
  # 
  # @return [Page] the rendered webpage for editing a password
  # 
  # @author lamb
  # 
  # @api public
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