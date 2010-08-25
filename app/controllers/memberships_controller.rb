class MembershipsController < ApplicationController

  # defaults :resource_class => Membership, :collection_name => 'memberships', :instance_name => 'membership'

  # belongs_to :project, :user, :finder => :get, :polymorphic => true

  # respond_to :html, :json

  def create
    if params.has_key?(:project_id)
      @project = Project.access_as(current_user).get(params[:project_id])
    else
      @project = Project.access_as(current_user).get(params[:id])
    end
  
    if params.has_key?(:user_id)
      @users = [User.access_as(current_user).get(params[:user_id])]
    else
      @users = User.access_as(current_user).all(:id => params[:memberships][:users])
    end
  
    @roles = Role.all(:id => params[:memberships][:roles])
  
    @users.each do |u|
     @roles.each do |r|
       @project.memberships.create(:user => u, :role => r)
     end
    end
  
    redirect_to(:back)
  end
  
  def destroy
    if params.has_key?(:project_id)
      @project = Project.access_as(current_user).get(params[:project_id])
    else
      @project = Project.access_as(current_user).get(params[:id])
    end
  
    if params.has_key?(:user_id)
      @user = User.access_as(current_user).get([params[:user_id]])
    else
      @user = User.access_as(current_user).get(params[:id])
    end
  
    memberships = @project.memberships.all(:user_id => @user.id)
    memberships.destroy
    redirect_to(:back)
  end
  
  def edit
    if params.has_key?(:project_id)
      @project = Project.access_as(current_user).get(params[:project_id])
    else
      @project = Project.access_as(current_user).get(params[:id])
    end
  
    if params.has_key?(:user_id)
      @user = User.access_as(current_user).get([params[:user_id]])
    else
      @user = User.access_as(current_user).get(params[:id])
    end

    # @role_names = Role.all(:id => Membership.all(:project => @project, :user => @user).map { |m| m.role_id }).map { |r| r.name }
    @role_names = @project.memberships(:user_id => @user.id).map{|m| m.role.name}
    respond_to do |format|
      format.html
    end
  end
  
  
  def update
    @project = Project.access_as(current_user).get(params[:project_id])
    @user = User.access_as(current_user).get(params[:id])
    @roles = Role.all(:id => params[:memberships][:roles])
  
    memberships = @project.memberships.all(:user_id => @user.id)
    memberships.destroy
  
    @roles.each do |role|
      @project.memberships.create(:user_id => @user.id, :role_id => role.id)
    end
    redirect_to(edit_project_url(@project))
  end
  
end