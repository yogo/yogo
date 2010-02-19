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
    # # If we are scoping this to the bread crumbs, construst our query
    # if session[:breadcrumbs][:current_model].eql?(@model) && !session[:breadcrumbs][:terms].empty?
    #   first_term = session[:breadcrumbs][:terms].first
    #   @query = @model.all(first_term[0].to_sym => first_term[1])
    #   session[:breadcrumbs][:terms][1..-1].each{|term| @query = @query & @model.all(term[0].to_sym => term[1])}
    # else
    #   # The query is everything.
    #   @query = @model.all
    # end
    # @data = @query.paginate(:page => params[:page], :per_page => 10)
    @query = @model.all
    @data = @query.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json { @data = @query.all if params[:page].blank?; render( :json => @data.to_json )}
      format.csv { download_csv }
    end
  end
  
  # Search the current model for the search parameters.
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
    goober = "yogo_#{@project.namespace.underscore}_#{@model.name.demodulize.underscore}"

    @item = @model.new(params[goober])
    
    if @item.valid?
      if @item.save
        flash[:notice] = "New \"#{@model.name.demodulize}\" has been created."
        redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
      else
        flash[:error] = "\"#{@model.name.demodulize}\" could not be created."
        render :action => :new
      end
    else
      flash[:error] = "\"#{@model.name.demodulize}\" could not be created: data is invalid."
      render :action => :new
    end
  end
  
  # Updates a data item to the current yogo project model
  #
  def update
    @item = @model.get(params[:id])
    goober = "yogo_#{@project.namespace.underscore}_#{@model.name.demodulize.underscore}"
    @item.attributes = params[goober]
    @item.save
    redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
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

        if Yogo::CSV.validate_csv(@model, csv_data[0..1])
          Yogo::CSV.load_data(@model, csv_data)
          flash[:notice] = "Model Data Successfully Uploaded."
        else
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
        end
      end
      redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
    end
  end

  def histogram_attribute
    @attribute_name = params[:attribute_name]
    @histogram = nil
    if @query_scope.nil? || @query_scope.name != @model.name
      @histogram = Yogo::Navigation.values(@model, @attribute_name.to_sym)
    else
      @histogram = Yogo::Navigation.values(@query_scope, @attribute_name.to_sym)
    end

    
    respond_to do |wants|
      wants.html 
      wants.js { render :partial => 'histogram_attribute' }
    end
  end
  
  def pick_attribute
    # session[:breadcrumbs] ||= { :current_model => nil, :current_project => nil }
    # 
    # if session[:breadcrumbs][:current_model] != @model
    #   session[:breadcrumbs][:current_project] = @project
    #   session[:breadcrumbs][:current_model] = @model
    #   session[:breadcrumbs][:terms] = []
    # end
    # 
    # session[:breadcrumbs][:terms] << [ params[:attribute], params[:value] ]
    
    redirect_to( project_yogo_data_index_path(@project, @model.name.demodulize) )

  end
  
  def remove_attribute
    # base_attribute = params[:attribute]
    # if session[:breadcrumbs][:current_model].name.demodulize == base_attribute
    #   session[:breadcrumbs][:terms] = []
    # else
    #   found = false
    #   session[:breadcrumbs][:terms]= session[:breadcrumbs][:terms].select do |t|
    #     found = t[0] == base_attribute
    #     found
    #   end
    # end
    
    redirect_to( project_yogo_data_index_path(@project, @model.name.demodulize) )
  end
  
  private
  
  # Allows download of yogo project model data in CSV format
  # 
  def download_csv
    send_data(Yogo::CSV.make_csv(@model, true), 
              :filename    => "#{@model.name.demodulize.tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end
  
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
  end
end
