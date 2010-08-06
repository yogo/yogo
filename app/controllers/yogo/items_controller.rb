class Yogo::ItemsController < Yogo::BaseController
  defaults :collection_name => 'items',
           :instance_name => 'items'
  
  belongs_to :project, :parent_class => Yogo::Project, :finder => :get, :collection_name => :data_collections
  belongs_to :data_collection, :parent_class => Yogo::Collection::Data, :finder => :get, :param => :collection_id

  protected
  
  def collection
    debugger
    @items ||= end_of_association_chain.all
  end
  
  def resource
    @item ||= collection.get(params[:id])
  end
  
  private
  
  def method_for_association_build
    :new
  end
  
  
end