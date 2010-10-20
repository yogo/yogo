class ValueTypeCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @value_type = ValueTypeCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:value_type_c_v].nil?
      @value_type = ValueTypeCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @value_type = ValueTypeCV.new(params[:variable_name_c_v])
    end
    respond_to do |format|
      if @value_type.save
        flash[:notice] = 'Value Type was successfully created.'
        format.html { (redirect_to(new_value_type_c_v_path())) }
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