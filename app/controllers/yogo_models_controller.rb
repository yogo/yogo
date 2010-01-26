class YogoModelsController < ApplicationController
  before_filter :find_parent_items
  
  def index
    @models = @project.models
  end
  
  def show
    @model = @project.get_model(params[:id])
  end
  
  def edit
    @model = @project.get_model(params[:id])
  end

  def update
    @model = @project.get_model(params[:id])
    # Needs to be implemented
    redirect_to project_yogo_model_url(@project, @model.name.split("::")[-1])
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