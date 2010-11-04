class UsersController < InheritedResources::Base
  respond_to :html, :json

  defaults :resource_class => User,
           :collection_name => 'users',
           :instance_name => 'user'

  def update
    # Remove these if they were sent.
    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)

    update!

    redirect_to(:back)
  end

  def destroy
    @user = resource_class.get(params[:id])
    if @user.eql?(current_user)
      flash[:notice] = "You can't destroy yourself"
      redirect_to(users_url)
    else
      destroy!
    end
  end

  def api_key_update
    @user = resource_class.get(params[:id])
    if @user.generate_new_api_key!
      flash[:notice] = "Updated API Key"
    else
      flash[:error] = "Failed to update API Key"
    end
    redirect_to(:back)
  end

  protected

  def resource
    @user ||= resource_class.get(params[:id])
  end

  def collection
    @users ||= resource_class.paginate(:page => params[:page], :per_page => 20, :order => 'login')
  end

  def resource_class
    User.access_as(current_user)
  end

end
