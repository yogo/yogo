class SampleMediumCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @sample_medium = SampleMediumCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:sample_medium_c_v].nil?
      @sample_medium = SampleMediumCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @sample_medium = SampleMediumCV.new(params[:sample_medium_c_v])
    end
    respond_to do |format|
      if @sample_medium.save
        flash[:notice] = 'Sample Medium was successfully created.'
        format.html { (redirect_to(new_sample_medium_c_v_path())) }
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