class YogoDataController < ApplicationController
  before_filter :find_parent_items
  
  def index
    @data = @model.all
  end
  
  def show
    @item = @model.get(params[:id])
  end
  
  def edit
    @item = @model.get(params[:id])
  end

  def update
    @item = @model.get(params[:id])
    goober = "yogo_#{@project.project_key.underscore}_#{@model.name.split("::")[-1].underscore}"
    @item.attributes = params[goober]
    @item.save
    redirect_to project_yogo_data_url(@project, @model.name.split("::")[-1])
  end  
  
  def destroy
    @model.get(params[:id]).destroy!
    redirect_to project_yogo_data_index_url(@project, @model.name.split("::")[-1])
  end
  
  def upload_csv
    flash[:notice] = "Data upload on models is not supported yet."
    redirect_to project_yogo_data_index_url(@project, @model.name.split("::")[-1])
  end
  
  def download_csv
    flash[:notice] = "Data download on models is not supported yet."
    redirect_to project_yogo_data_index_url(@project, @model.name.split("::")[-1])    
  end

  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
    @model.send(:include, Yogo::Pagination)
  end
end