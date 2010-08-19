class RolesController < InheritedResources::Base

  belongs_to :project, :user, :optional => true

  def create
    create! do |format|
      format.html { redirect_to(roles_url) }
    end
  end

  def update
    update! do |format|
      format.html { redirect_to(roles_url) }
    end
  end

  def delete
    delete! do |format|
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
  
  def resource_class
    Role.access_as(current_user)
  end

end
