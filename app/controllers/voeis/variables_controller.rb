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
    @variables = Variable.all
    @variable = Variable.new
    @units = Unit.all
    @variable_names = VariableNameCV.all
    @sample_mediums= SampleMediumCV.all
    @value_types= ValueTypeCV.all
    @speciations = SpeciationCV.all
    @data_types = DataTypeCV.all
    @general_categories = GeneralCategoryCV.all
    @label_array = Array["Variable Name","Variable Code","Unit Name","Speciation","Sample Medium","Value Type","Is Regular","Time Support","Time Unit ID","Data Type","General Cateogry", "Detection Limit"]
    @current_variables = Array.new     
    @variables.all(:order => [:variable_name.asc]).each do |var|
      @temp_array =Array[var.variable_name, var.variable_code,@units.get(var.variable_units_id).units_name, var.speciation,var.sample_medium, var.value_type, var.is_regular.to_s, var.time_support.to_s, var.time_units_id.to_s, var.data_type, var.general_category, var.detection_limit.to_s]
      @current_variables << @temp_array
    end         
    @project = parent
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  # POST /variables
  def create
    @variable = Variable.new(params[:variable])
    if @variable.detection_limit.empty?
      @variable.detection_limit = nil
    end
    if @variable.save  
      flash[:notice] = 'Variable was successfully created.'
      redirect_to(new_project_variable_path(parent))
    else
      respond_to do |format|
        flash[:warning] = 'There was a problem saving the Variables.'
        format.html { render :action => "new" }
      end
    end
  end
end
