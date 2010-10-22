class LabMethodsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /lab_methods/new
  def new
    @lab_method = LabMethod.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /lab_methods
  def create
    if params[:lab_method].nil?
      @lab_method = LabMethod.new(:lab_name=> params[:lab_name], :lab_organization => params[:lab_organization], :lab_method_name => params[:lab_method_name], :lab_method_description => params[:lab_method_description])
    else
      @lab_method = LabMethod.new(params[:lab_method])
    end
    respond_to do |format|
      if @lab_method.save
        flash[:notice] = 'Lab Method was successfully created.'
        format.html { (redirect_to(new_lab_method_c_v_path())) }
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