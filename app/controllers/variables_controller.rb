class VariablesController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @variable = Voeis::Variable.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create

    @variable = Voeis::Variable.new(params[:variable])


    respond_to do |format|
      if @variable.save
        flash[:notice] = 'Variables was successfully created.'
        format.json do
          render :json => @variable.as_json, :callback => params[:jsoncallback]
        end
        format.html { (redirect_to(variable_path( @variable.id))) }
      else
        format.html { render :action => "new" }
      end
    end
  end
  def show
    respond_to do |format|
      format.json do
        
      end
    end
  end
  


  def invalid_page
    redirect_to(:back)
  end
end