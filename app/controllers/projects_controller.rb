class ProjectsController < InheritedResources::Base
  respond_to :html, :json
  
  protected
  def resource
    @project ||= resource_class.get(params[:id])
  end

  def collection
    @projects ||= resource_class.all
  end

  def resource_class
    @initial_query ||= begin
      q = Project.all(:is_private => false)
      q =  (q | current_user.projects ) unless current_user.nil?
      q.access_as(current_user)
    end
  end
end