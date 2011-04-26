require 'responders/rql'

class QualityControlLevelsController  < InheritedResources::Base
  rescue_from ActionView::MissingTemplate, :with => :invalid_page
  responders :rql
  defaults  :route_collection_name => 'quality_control_levels',
            :route_instance_name => 'quality_control_level',
            :collection_name => 'quality_control_levels',
            :instance_name => 'quality_control_level',
            :resource_class => Voeis::QualityControlLevel

  # GET /variables/new
  def new
    @quality_control_level = Voeis::QualityControlLevel.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # POST /variables
  def create
    if params[:quality_control_level].nil?
      @quality_control_level = Voeis::QualityControlLevel.new(:term=> params[:term], :definition => params[:definition])
    else
      @quality_control_level = Voeis::QualityControlLevel.new(params[:quality_control_level])
    end
    respond_to do |format|
      if @quality_control_level.save
        flash[:notice] = 'Quality Control Level was successfully created.'
        format.json do
          render :json => @quality_control_level.as_json, :callback => params[:jsoncallback]
        end
        format.html { (redirect_to(new_quality_control_level_path())) }
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