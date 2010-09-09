class UserSessionsController < ApplicationController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:destroy]

  ##
  # Redirects to new user_session action
  #
  # @example
  #   get /user_sessions/new
  #
  # @return [Redirect] Redirects to login url
  #
  # @author lamb
  #
  # @api public
  def show
    redirect_to login_url
  end

  ##
  # Renders a login page
  #
  # @example
  #   get /user_sessions/new
  #   get /login
  #
  # @return [HTML] The login page
  #
  # @author lamb
  #
  # @api public
  def new
    render :action => 'new'
  end

  ##
  # Renders a login page
  #
  # @example
  #   get /user_sessions/new
  #   get /login
  #   get /unauthenticated
  #
  # @return [HTML] The login page
  #
  # @author lamb
  #
  # @api public
  alias :unauthenticated :new

  ##
  # Logs a user in or rerenders the login page
  #
  # @example
  #   post /user_sessions
  #
  # @return [Redirect or HTML]
  #   Redirects or rerenders the login page
  #
  # @author lamb
  #
  # @api public
  def create
    if authenticate!
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  ##
  # Logs out a user
  #
  # @example
  #   delete /user_sessions/
  #   delete /logout
  #
  # @return [HTML] The login page
  #
  # @author lamb
  #
  # @api public
  def destroy
    logout
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end

end