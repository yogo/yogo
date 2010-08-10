class RolesController < ApplicationController
  inherit_resources

  def create
    super do |format|
      format.html { redirect_to(roles_url) }
    end
  end

  def update
    super do |format|
      format.html { redirect_to(roles_url) }
    end
  end

  protected

  def collection
    @roles ||= resource_class.all
  end

  def resource
    @role ||= resource_class.get(params[:id])
  end

  def update_resource(object, attributes)
    object.attributes = attributes
    object.save
  end
end
