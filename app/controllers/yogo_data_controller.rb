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
  
  def upload
    flash[:notice] = "Data upload on models is not supported yet."
    redirect_to project_yogo_data_index_url(@project, @model.name.split("::")[-1])
  end
  
  def download
    csv_output = FasterCSV.generate do |csv|
      csv << @model.properties.map{|prop| prop.name.to_s.capitalize}
      csv << @model.properties.map{|prop| prop.type}
      csv << "Units will go here when supported"
    end

    csv_output << @model.all.to_csv if params[:include_data]
    
    send_data(csv_output, :filename => "#{@model.name.split("::")[-1].tableize.singular}.csv", :type => "text/csv", :disposition => 'attachment')
  end

  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
    @model.send(:include, Yogo::Pagination)
  end
end