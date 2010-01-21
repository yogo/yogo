class YogoCollectionsController < ApplicationController
  before_filter :find_project
  
  def index 
    @models = @project.yogo_collection.models
  end
  
  def show
    @model = @project.yogo_collection.get_model(params[:id])
    @model.send(:include, Yogo::Pagination)
    @data = @model.paginate(:page => params[:page ])
  end
  
  def edit
  end
  
  def show_data
    # this needs to actually find data (and be in a sensible place)
    @yogo_data = Yogo::Collection.get(params[:id]).yogo_data(params[:schema]).first
  end
  
  private
  
  def find_project
    @project = Project.get(params[:project_id])
  end
end