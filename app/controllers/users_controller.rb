class UsersController < ApplicationController
  inherit_resources

  belongs_to :project
  belongs_to :role

  protected

  def collection
    @users ||= resource_class.all
  end

  def resource
    @user ||= resource_class.get(params[:id])
  end

  def update_resource(object, attributes)
    object.attributes = attributes
    object.save
  end
end
