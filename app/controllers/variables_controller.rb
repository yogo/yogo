class VariablesController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page


  # GET /variables/new
  def new
    @variable = Variable.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:variable].nil?
      @variable = Variable.new(:variable_code=> params[:variable_code], :variable_name => params[:variable_name], :speciation => params[:speciation], :variable_units_id => params[:variable_units_id], :sample_medium=>params[:sample_medium],:value_type=>params[:value_type],
      :is_regular=>params[:is_regular], :time_support=>params[:time_support],:time_units_id=>params[:time_units_id], :data_type=>params[:data_type], :general_category=>params[:general_category], :no_data_value=>params[:no_data_value], :updated_at=>Time.now, :detection_limit=>params[:detection_limit])
    else
      @variable = Variable.new(params[:variable])
    end
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