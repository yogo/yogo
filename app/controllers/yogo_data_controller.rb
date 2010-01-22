class YogoDataController < ApplicationController
  before_filter :find_parent_items
  
  def show
    @item = @model.get(params[:id])
  end
  
  def edit
    @item = @model.get(params[:id])
  end

  def update
    @item = @model.get(params[:id])
    goober = "yogo_#{@project.yogo_collection.project_key.underscore}_#{@model.name.split("::")[-1].underscore}"
    @item.attributes = params[goober]
    @item.save
    redirect_to project_yogo_collection_url(@project, @model.name.split("::")[-1])
  end  
  
  def destroy
    @model.get(params[:id]).destroy!
    redirect_to project_yogo_collection_url(@project, @model.name.split("::")[-1])
  end
  
  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.yogo_collection.get_model(params[:yogo_collection_id])
  end
end