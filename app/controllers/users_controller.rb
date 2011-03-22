class UsersController < InheritedResources::Base
  respond_to :html, :json

  defaults :resource_class => User,
           :collection_name => 'users',
           :instance_name => 'user'

  def update
    # Remove these if they were sent.
    # 
    if params[:user].empty?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    update!
    # respond_to do |format|
    #   format.html do
    #     redirect_to(:back)
    #   end
    # end
  end
 
  def change_password
    user = User.get(params[:id])
    code = {:message => "Password Change Failed"}
    if params[:password] == params[:confirmation]
      user.password = params[:password]
      user.password_confirmation = params[:confirmation]
      user.save
      code = {:message =>"Password Change Was Successful"}
    end
    respond_to do |format|
      format.json do
        render :json => code.as_json, :callback => params[:jsoncallback]
      end
    end
  end

  def destroy
    @user = resource_class.get(params[:id].to_i)
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
    respond_to do |format|
      format.js
      format.html do
        redirect_to(:back)
      end
    end
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
