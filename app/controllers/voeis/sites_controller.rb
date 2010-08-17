class Voeis::SitesController < Yogo::BaseController

  belongs_to :project, :parent_class => Yogo::Project, :finder => :get

  protected

  def resource
    @site ||= collection.get(params[:id])
  end

  def collection
    @sites ||= site_collection.items
  end

  def resource_class
    site_collection.data_model
  end

  def site_collection
    @site_collection ||= Yogo::Collection::Static.first(:project => parent, :static_model => "Voeis::Site")
  end

end
