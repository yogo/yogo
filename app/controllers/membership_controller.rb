class MembershipsController < ApplicationController
  inherit_resources

  defaults :resource_class => Membership, :collection_name => 'memberships', :instance_name => 'membership'

  belongs_to :project, :finder => :get, :parent_class => Yogo::Project
  belongs_to :user, :finder => :get
  belongs_to :role, :finder => :get

  respond_to :html, :json

  def create
    if params.has_key?(:project_id)
      @project = Yogo::Project.get(params[:project_id])
    else
      @project = Yogo::Project.get(params[:id])
    end

    if params.has_key?(:user_id)
      @users = [User.get(params[:user_id])]
    else
      @users = params[:memberships][:users].map { |idx| User.get(idx) }
    end

    @roles = params[:memberships][:roles].map { |idx| Role.get(idx) }

    @users.each do |u|
     @roles.each do |r|
       Membership.create(:user => u, :role => r, :project => @project)
     end
    end

    redirect_to(:back)
  end

  def destroy
    if params.has_key?(:project_id)
      @project = Yogo::Project.get(params[:project_id])
    else
      @project = Yogo::Project.get(params[:id])
    end

    if params.has_key?(:user_id)
      @user = User.get([params[:user_id]])
    else
      @user = User.get(params[:id])
    end

    memberships = Membership.all(:user => @user, :project => @project)
    memberships.destroy
    redirect_to(:back)
  end

  def edit
    if params.has_key?(:project_id)
      @project = Yogo::Project.get(params[:project_id])
    else
      @project = Yogo::Project.get(params[:id])
    end

    if params.has_key?(:user_id)
      @user = User.get([params[:user_id]])
    else
      @user = User.get(params[:id])
    end

    @role_names = Role.all(:id => Membership.all(:project => @project, :user => @user).map { |m| m.role_id }).map { |r| r.name }

    respond_to do |format|
      format.html
    end
  end


  def update
    @project = Yogo::Project.get(params[:project_id])
    @user = User.get(params[:id])
    @roles = params[:memberships][:roles].map { |rid| Role.get(rid) }

    memberships = Membership.all(:user => @user, :project => @project)
    memberships.destroy

    @roles.each do |role|
      Membership.create(:user => @user, :project => @project, :role => role)
    end
    redirect_to(edit_yogo_project_url(@project))
  end
end