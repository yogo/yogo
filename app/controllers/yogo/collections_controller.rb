class Yogo::CollectionsController < InheritedResources::Base
  respond_to :html, :json
  
  defaults :resource_class => Yogo::Collection::Data,
           :collection_name => 'yogo_collection_data',
           :instance_name => 'yogo_collection_datum'
           
  belongs_to :project, :parent_class => Yogo::Project,
             :finder => :get

  protected
  
  def collection
    @collections ||= end_of_association_chain.all
  end
  
  def resource
    @collection ||= collection.get(params[:id])
  end
  
end