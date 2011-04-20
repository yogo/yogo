class VisitsController < InheritedResources::Base
  rescue_from ActionView::MissingTemplate, :with => :invalid_page

  defaults  :route_collection_name => 'visits',
            :route_instance_name => 'visit',
            :collection_name => 'visits',
            :instance_name => 'visit',
            :resource_class => Voeis::Visit

  def invalid_page
    redirect_to(:back)
  end
end