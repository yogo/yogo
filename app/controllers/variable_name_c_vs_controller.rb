class VariableNameCVsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @variable_name = Voeis::VariableNameCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:variable_name_c_v].nil?
      @variable_name = Voeis::VariableNameCV.new(:term=> params[:term], :definition => params[:definition])
    else
      @variable_name = Voeis::VariableNameCV.new(params[:variable_name_c_v])
    end
    respond_to do |format|
      if @variable_name.save
        flash[:notice] = 'Variable Name was successfully created.'
        format.html { (redirect_to(new_variable_name_c_v_path())) }
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