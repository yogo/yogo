class FieldMethodsController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /field_methods/new
  def new
    @field_method = FieldMethod.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /field_methods
  def create
    if params[:field_method].nil?
      @field_method = FieldMethod.new(:method_description=> params[:field_method_description], :method_link => params[:method_link])
    else
      @field_method = FieldMethod.new(params[:field_method])
    end
    respond_to do |format|
      if @field_method.save
        flash[:notice] = 'Field Method was successfully created.'
        format.html { (redirect_to(new_field_method_c_v_path())) }
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