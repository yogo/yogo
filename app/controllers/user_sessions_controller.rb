class UserSessionsController < ApplicationController

  # require_user    :for => :destroy
  # require_no_user :for => [:new, :create]
  # authorize_group :default
  before_filter :require_no_user, :only => [:new,:create]
  before_filter :require_user,    :only => [:destroy]
  
  # before_filter :require_auth, :only => [:destroy]
  
  def show
    redirect_to login_url
  end
  
  def new
    render :action => 'new'
  end
  
  alias :unauthenticated :new
  
  def create
    # @user_session = UserSession.new(params[:user_session])
    # if @user_session.save
    if authenticate!
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end
  
  def destroy
    # current_user_session.destroy
    logout
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_url
  end
  
  private
  
  def require_auth
    authenticated?
  end

  def require_no_auth
    !logged_in?
  end
  
end