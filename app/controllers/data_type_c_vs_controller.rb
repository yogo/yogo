class DataTypeCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @data_type = Voeis::DataTypeCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:data_type_c_v].nil?
      @data_type = Voeis::DataTypeCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @data_type = Voeis::DataTypeCV.new(params[:data_type_c_v])
    end
    respond_to do |format|
      if @data_type.save
        flash[:notice] = 'Data Type was successfully created.'
        format.html { (redirect_to(new_data_type_c_v_path())) }
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