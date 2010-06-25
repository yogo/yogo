class UsersController < ApplicationController
  before_filter :require_user
  before_filter :require_administrator

  ##
  # Retrieves all users in the system
  #
  # @example
  #   get /users
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def index
    @users = User.all
  end

  ##
  # Retrieves a user in the system
  #
  # @example
  #   get /users/42
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def show
    @user = User.get(params[:id])
  end

  ##
  # Retrieves a user in the system
  #
  # @example
  #   get /users/42
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def show
    @user = User.get(params[:id])
  end

  ##
  # Create a new user in the system
  #
  # @example
  #   get /users/new
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def new
    @user = User.new
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
  # @api public
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.valid?
        @user.save
        flash[:notice] = "User created"
        format.html { redirect_to(users_url) }
      else
        flash[:error] = "User was unable to be created"
        format.html { render(:action => 'new') }
      end
    end
  end

  ##
  # Retrieves a user in the system for editing
  #
  # @example
  #   get /users/42/edit
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def edit
    @user = User.get(params[:id])
  end

  ##
  # Updates a user in the system
  #
  # @example
  #   put /users/42 {:user => {:login => 'user_42'}}
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def update
    @user = User.get(params[:id])

    @user.attributes = params[:user]

    respond_to do |format|
      if @user.valid?
        @user.save
        flash[:notice] = "User updated"
        format.html { redirect_to(user_url(@user)) }
      else
        flash[:error] = "There was an error updating the user"
        format.html { render(:action => 'edit') }
      end
    end
  end

  ##
  # Destroys a user in the system
  #
  # @example
  #   delete /users/42
  #
  # @return [HTML]
  #  html response
  #
  # @api public
  def destroy
    user = User.get(params[:id])

    if user.eql?(current_user)
      flash[:notice] = "You can't destroy yourself"
    elsif user.destroy
      flash[:notice] = "#{user.name} removed from system"
    else
      flash[:error] = "Something went wrong removing the user"
      # Should this throw an exception?
    end
    
    respond_to do |format|
      format.html { redirect_to(users_url) }
    end
    
  end
  
  private

  ##
  # Checks to see if the current user is in the administrator group
  # @return [nil] or it doesn't return.
  # @api private
  def require_administrator
    authorization_denied unless current_user.groups.any?{|g| g.admin? }
  end
    
end
