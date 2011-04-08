class SampleMaterialsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /sample_materials/new
  def new
    @sample_material = Voeis::SampleMaterial.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /sample_materials
  def create
    @sample_material = Voeis::SampleMaterials.new(params[:sample_material])

    respond_to do |format|
      if @sample_material.save
        flash[:notice] = 'Sample Material was successfully created.'
        format.html { (redirect_to(sample_material_path( @sample_material.id))) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  def show
    
  end

  def invalid_page
    redirect_to(:back)
  end
end