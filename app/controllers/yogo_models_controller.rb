class YogoModelsController < ApplicationController
  before_filter :find_parent_items
  
  Human_types = { "Decimal"        => BigDecimal, 
                  "Integer"        => Integer,
                  "Text"           => String, 
                  "True/False"     => DataMapper::Types::Boolean, 
                  "Date"           => DateTime }
  
  def index
    @models = @project.models
  end
  
  def show
    @model = @project.get_model(params[:id])
    @types = Human_types.invert
  end
  
  def edit
    @model = @project.get_model(params[:id])
    @options = Human_types.keys.collect{|key| [key,key] }
    @types = Human_types.invert
  end

  def update
    @model = @project.get_model(params[:id])
    prop_name = params[:name].downcase
    prop_type = Human_types[params[:type]]
    # This stuff need to be pushed down into the model. In due time.
    
    # Type Checking
    if !prop_type.nil? &&
        !prop_name.blank? &&
        
      @model.send(:property, prop_name.to_sym, prop_type, :required => false)
      @model.auto_migrate_up!
      flash[:notice] = "Property #{prop_name} added"
      
      redirect_to project_yogo_model_url(@project, @model.name.split("::")[-1])
    else
      flash[:notice] = "Property NOT added."
      redirect_to edit_project_yogo_model_url(@project, @model.name.split("::")[-1])
    end

  end  
  
  def destroy
    model = @project.get_model(params[:id])
    @project.delete_model(model)
    redirect_to project_yogo_models_url(@project)
  end
  
  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
  end
end