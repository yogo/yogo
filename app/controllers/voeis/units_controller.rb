class Voeis::UnitsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'units',
            :route_instance_name => 'unit',
            :collection_name => 'units',
            :instance_name => 'unit',
            :resource_class => Voeis::Unit
            
  # GET /variables/new
  def new
    @unit = Voeis::Unit.new
    @project = parent
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  # POST /variables
  def create
    @unit = Voeis::Unit.new(params[:unit])

    if @unit.save  
      flash[:notice] = 'Unit was successfully created.'
      redirect_to(project_path(parent))
    else
      respond_to do |format|
        flash[:warning] = 'There was a problem saving the Unit.'
        format.html { render :action => "new" }
      end
    end
  end
end
