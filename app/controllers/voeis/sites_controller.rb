class Voeis::SitesController < Yogo::BaseController

  belongs_to :project, :parent_class => Yogo::Project, :finder => :get

  protected

  def resource
    @site ||= collection.get(params[:id])
  end

  def collection
    parent.with_storage do 
      @sites ||= Voeis::Sites.all
    end
  end
end
