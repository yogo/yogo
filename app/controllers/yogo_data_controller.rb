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
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
      else
        # Read the data in
        csv_data = FasterCSV.read(datafile.path)

        # Validate model properties
        prop_hash = Hash.new
        csv_data[0].each_index do |idx|
          prop_hash[csv_data[0][idx].tableize.singularize] = csv_data[1][idx]
        end

        valid = true
        @model.properties.each do |prop|
          valid = false unless prop_hash.has_key?(prop.name.to_s) && prop_hash[prop.name.to_s] == prop.type.to_s
        end

        if valid
          # Load data from csv file
          csv_data[3..-1].each do |line| 
            line_data = Hash.new
            csv_data[0].each_index { |i| line_data[csv_data[0][i].downcase] = line[i].strip }
            item = @model.get(line_data['id'])
            if ! item.nil?
              item.attributes = line_data
              item.save
            else
              @model.create(line_data)
            end
          end
          flash[:notice] = "Model Data Successfully Uploaded."
        else
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
        end
      end
      redirect_to project_yogo_data_index_url(@project, @model.name.split("::")[-1])
    end
  end
  
  def download
    csv_output = FasterCSV.generate do |csv|
      csv << @model.properties.map{|prop| prop.name.to_s.capitalize}
      csv << @model.properties.map{|prop| prop.type}
      csv << "Units will go here when supported"
    end

    csv_output << @model.all.to_csv if params[:include_data]
    
    send_data(csv_output, 
              :filename    => "#{@model.name.split("::")[-1].tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end

  private
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
    @model.send(:include, Yogo::Pagination)
  end
end