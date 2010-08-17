class UsersController < InheritedResources::Base
  before_filter :require_user
  
  respond_to :html, :json
  
  defaults :resource_class => User,
           :collection_name => 'users',
           :instance_name => 'user'
  
  def update
    # Remove these if they were sent.
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)
    update!
  end
  
  def destroy
    @user = User.get(params[:id])
    if @user.eql?(current_user)
      flash[:notice] = "You can't destroy yourself"
      redirect_to(users_url)
    else
      destroy!
    end
  end
  
  
  protected

  def resource
    @user ||= collection.get(params[:id]).access_as(current_user)
  end
  
  def collection
    @users ||= resource_class.all.paginate(:page => params[:page], :per_page => 25, :order => 'login')
  end
  
  def resource_class
    User.access_as(current_user)
  end
  
end
