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
    parent.managed_repository do
      if params[:sample_material].nil?
        @sample_material = Voeis::SampleMaterial.new(:material=> params[:material], :description => params[:description])
      else
        @sample_material = Voeis::SampleMaterial.new(params[:sample_material])
      end
      respond_to do |format|
        if @sample_material.save
          flash[:notice] = 'Sample Material was successfully created.'
          format.html { (redirect_to(new_project_sample_material_path())) }
          format.js
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def invalid_page
    redirect_to(:back)
  end
end