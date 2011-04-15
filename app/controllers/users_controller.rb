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
  
  def forgot_password
    
  end
  
  def email_reset_password
    @message = ""
    @result = false
    user = User.first(:login => params[:username], :email=>params[:email])
    if user.nil?
      @message = "We could not find a user matching the combination for username:#{params[:username]} and email address:#{params[:email]}"
    else
      o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;  
      string  =  (0..50).map{ o[rand(o.length)]  }.join;
      user.password = string[0..10]
      user.password_confirmation = string[0..10]
      if user.save
        @message = "You reset password will be emailed to you."
        VoeisMailer.email_user(user.email, "VOEIS Password Rest", "Your VOEIS password has been reset to: #{string[0..10]}\n\nIf this was not you please contact the VOEIS Administrator\n\nThank You,\n VOEIS" )
        @result = true
      else
        @message = "We were unable to reset your password - please contact an Administrator for assistance."
      end
    end  
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
