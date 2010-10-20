class Voeis::VariablesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'variables',
            :route_instance_name => 'variable',
            :collection_name => 'variables',
            :instance_name => 'variable',
            :resource_class => Voeis::Variable


  # GET /variables/new
  def new
    @variable = Variable.new
    @units = Unit.all
    @variable_names = VariableNameCV.all
    @sample_mediums= SampleMediumCV.all
    @value_types= ValueTypeCV.all
    @project = parent
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  # POST /variables
  def create
    @variable = Variable.new(params[:variable])
    
    if @variable.save  
      flash[:notice] = 'Variable was successfully created.'
      redirect_to(project_path(parent))
    else
      respond_to do |format|
        flash[:warning] = 'There was a problem saving the Variables.'
        format.html { render :action => "new" }
      end
    end
  end
end
