class ProjectsController < InheritedResources::Base
  respond_to :html, :json
  
  
  protected
  def resource
    @project ||= collection.get(params[:id])
  end

  def collection
    @projects ||= resource_class.all
  end

  def resource_class
    Project
  end
end