# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# Functionality for CRUD of data within a yogo project's model
# Additionally upload and download of data via CSV is provided
#
class YogoDataController < ApplicationController
  before_filter :find_parent_items
 
  #  Display's paginated data items from the selected yogo project model
  # 
  # * 10 data objects per page are displayed
  def index
    @data = @model.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json { @data = @model.all if params[:page].blank?; render( :json => @data.to_json )}
      format.csv { download_csv }
    end
  end
  
  # Search
  #
  def search
    search_term = params[:search_term]
    @data = @model.search(search_term)
    
    respond_to do |format|
      format.html { render( :action => :index) }
      format.json { render( :json => @data.to_json )}
      format.csv  { download_csv}
    end
  end
  
  # Displays a yogo project model data item's properites and values
  # 
  def show
    @item = @model.get(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render( :json => @item.to_json )}
    end
  end
  
  def new
    @item = @model.new
  end
  # Allows a user to edit a yogo project model data item's values
  #
  def edit
    @item = @model.get(params[:id])
  end

  def create
    @item = @model.new(params[:item])
    
    if @item.valid?
      puts @item
      if @item.save
        flash[:notice] = "New \"#{@model.name}\" has been created."
        redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
      else
        flash[:error] = "\"#{@model.name}\" could not be created."
        render :action => :new
      end
    else
      flash[:error] = "\"#{@model.name}\" could not be created: data is invalid."
      render :action => :new
    end
  end
  # Adds a data item to the current yogo project model
  #
  def update
    @item = @model.get(params[:id])
    goober = "yogo_#{@project.project_key.underscore}_#{@model.name.demodulize.underscore}"
    @item.attributes = params[goober]
    @item.save
    redirect_to project_yogo_data_url(@project, @model.name.demodulize)
  end  
  
  # Deletes a yogo project model's selected datum
  # 
  def destroy
    @model.get(params[:id]).destroy!
    redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
  end
  
  # Accepts the upload of a CSV file
  # 
  def upload
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values',  
             'application/vnd.ms-excel'].include?(datafile.content_type)
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
#          puts "Condition 1: [attr exists] #{prop_hash.has_key?(prop.name.to_s)}"
#          puts "Condition 2: [type matches] #{prop_hash[prop.name.to_s] == Yogo::Types.dm_to_human(prop.type)}"
          valid = false unless (prop_hash.has_key?(prop.name.to_s) && 
                                prop_hash[prop.name.to_s] == Yogo::Types.dm_to_human(prop.type))
        end

        if valid
          # Load data from csv file
          csv_data[3..-1].each do |line| 
            line_data = Hash.new
            csv_data[0].each_index { |i| line_data[csv_data[0][i].tableize.singularize] = line[i] }
            if line_data.has_key?('id') && ! @model.get(line_data['id']).nil?
              item = @model.get(line_data['id'])
              item.attributes = line_data
              item.save
            else
              line_data.delete('id') if line_data.has_key?('id')
              @model.create(line_data)
            end
          end
          flash[:notice] = "Model Data Successfully Uploaded."
        else
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
        end
      end
      redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
    end
  end
  
  private
  
  # Allows download of yogo project model data in CSV format
  # 
  def download_csv
    csv_output = FasterCSV.generate do |csv|
      csv << @model.properties.map{|prop| prop.name.to_s.humanize}
      csv << @model.properties.map{|prop| Yogo::Types.dm_to_human(prop.type)}
      csv << "Units will go here when supported"
    end

    @model.all.each { |m| csv_output << m.to_csv }
    
    send_data(csv_output, 
              :filename    => "#{@model.name.demodulize.tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
    @model.send(:include, Yogo::Pagination)
  end
end
