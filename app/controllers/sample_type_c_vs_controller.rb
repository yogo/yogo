class SampleTypeCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @sample_type = SampleTypeCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:sample_type_c_v].nil?
      @sample_type = SampleTypeCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @sample_type = SampleTypeCV.new(params[:sample_type_c_v])
    end
    respond_to do |format|
      if @sample_type.save
        flash[:notice] = 'Sample Type was successfully created.'
        format.html { (redirect_to(new_sample_type_c_v_path())) }
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