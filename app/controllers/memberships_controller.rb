class MembershipsController < ApplicationController
  inherit_resources

  defaults :resource_class => Membership, :collection_name => 'memberships', :instance_name => 'membership'

  belongs_to :project, :finder => :get, :parent_class => Project

  respond_to :html, :json

  def create
    @project = Project.get(params[:project_id])
    @users = params[:memberships][:users].values.map { |idx| User.get(idx) }
    @roles = params[:memberships][:roles].values.map { |idx| Role.get(idx) }

    @users.each do |u|
     @roles.each do |r|
       Membership.create(:user => u, :role => r, :project => @project)
     end
    end

    redirect_to(:back)
  end
end