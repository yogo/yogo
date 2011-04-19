class CampaignsController < InheritedResources::Base
  rescue_from ActionView::MissingTemplate, :with => :invalid_page

  defaults  :route_collection_name => 'campaigns',
            :route_instance_name => 'campaign',
            :collection_name => 'campaigns',
            :instance_name => 'campaign',
            :resource_class => Voeis::Campaign

  def invalid_page
    redirect_to(:back)
  end
end