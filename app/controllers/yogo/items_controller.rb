class Yogo::ItemsController < InheritedResources::Base
  respond_to :html, :json
  
  defaults :collection_name => 'items',
           :instance_name => 'items'
           
  belongs_to :project, :parent_class => Yogo::Project, :finder => :get do
    belongs_to :collection, :parent_class => Yogo::Collection, :finder => :get
  end

  protected
  
  def collection
    @items ||= end_of_association_chain.all
  end
  
  def resource
    @item ||= collection.get(params[:id])
  end
  
end