class Yogo::ItemsController < Yogo::BaseController
  defaults :collection_name => 'items',
           :instance_name => 'items'
  
  belongs_to :project, :parent_class => Yogo::Project, :finder => :get, :collection_name => :data_collections
  belongs_to :data_collection, :parent_class => Yogo::Collection::Data, :finder => :get, :param => :collection_id
  
  protected
  
  def collection
    @items ||= end_of_association_chain.all
  end
  
  def resource
    @item ||= collection.get(params[:id])
  end
  
  with_responder do
    def resource_json(item)
      data_collection = controller.send(:parent)
      project = data_collection.project
      
      hash = item.as_json
      hash[:uri] = controller.send(:yogo_project_collection_item_path, project, data_collection, item)
      hash[:data_collection] = controller.send(:yogo_project_collection_path, project, data_collection)
      hash
    end
  end
  
  private
  
  def method_for_association_build
    :new
  end
  
  
end