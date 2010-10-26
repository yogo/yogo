class Voeis::SampleMaterialsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'sample_materials',
            :route_instance_name => 'sample_material',
            :collection_name => 'sample_materials',
            :instance_name => 'sample_material',
            :resource_class => Voeis::SampleMaterial

  # GET /sample_materials/new
  def new
    @project = parent
  end


  def create
     create! do |success, failure|
      success.html { redirect_to project_url(parent) }
    end
  end

  def invalid_page
    redirect_to(:back)
  end
end