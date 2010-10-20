class SpeciationCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @speciation = SpeciationCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:speciation_c_v].nil?
      @speciation = SpeciationCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @speciation = SpeciationCV.new(params[:speciation_c_v])
    end
    respond_to do |format|
      if @speciation.save
        flash[:notice] = 'Speciation was successfully created.'
        format.html { (redirect_to(new_speciation_c_v_path())) }
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