class Yogo::CollectionsController < Yogo::BaseController
  defaults :resource_class => Yogo::Collection::Data,
           :collection_name => 'data_collections',
           :instance_name => 'data_collection'
           
  belongs_to :project, :parent_class => Yogo::Project,
             :finder => :get
  
  protected
  
  def collection
    @data_collections ||= end_of_association_chain.all
  end
  
  def resource
    @data_collection ||= collection.get(params[:id])
  end
  
  with_responder do
    def resource_json(resource)
      hash = super(resource)
      hash[:project] = controller.send(:yogo_project_path, resource.project)
      hash[:schema] =  resource.schema.map do |prop|
        controller.send(:yogo_project_collection_property_path, resource.project, resource, prop)
      end
      hash
    end
  end
  
  private
  
  def method_for_association_build
    :new
  end
  
end