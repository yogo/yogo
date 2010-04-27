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
  before_filter :find_parent_items, :show_sidebar

  # 10 data objects per page are displayed
  #
  # @example http://localhost:3000/yogo_data
  #
  # @param [Hash] params
  # @option params [String] :q this is a querry
  #
  # @return [Array] Display's paginated data items from selected yogo project model
  #
  # @author Yogo Team
  #
  # @api public
  def index
    if !params[:q].nil?
      queries =[]
      params[:q].each_pair do |attribute, conditions|
        q = @model.all(attribute.to_sym => conditions[0])
        conditions[1..-1].each{ |c| q = q + @model.all(attribute.to_sym => c ) }
        queries << q
      end
      
      @query = queries.first
      queries[1..-1].each{|q| @query = @query & q }
      
    else
      # The query is everything.
      @query = @model.all
    end
    # @data = @query.paginate(:page => params[:page], :per_page => 10)
    # @query = @model.all
    @data = @query.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json { @data = @query.all if params[:page].blank?; render( :json => @data.to_json )}
      format.csv { download_csv }
    end
  end

  # this searches projects and models for seach_term
  #
  # @example http://localhost:3000/yogo_data
  #
  # @param [Hash] params
  # @option params [String] :search_term
  #
  # @return [Array] Search the current model for the search parameters
  #
  # @author Yogo Team
  #
  # @api public
  def search
    search_term = params[:search_term]
    @query = @model.search(search_term)
    
    @data = @query.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html { render( :action => :index) }
      format.json {  @data = @query.all, render( :json => @data.to_json )}
      format.csv  { download_csv}
    end
  end
  
  # this shows a model
  #
  # @example http://localhost:3000/yogo_data
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return [Model] Displays a yogo project model data item's properites and values
  #
  # @author Yogo Team
  #
  # @api public
  def show
    @item = @model.get(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render( :json => @item.to_json )}
    end
  end

  # Creates a new data object
  #
  # @example http://localhost:3000/yogo_data/new
  #
  # @return [Object] returns an empty data object
  #
  # @author Yogo Team
  #
  # @api public
  def new
    @item = @model.new
  end

  # edits a data object
  #
  # @example http://localhost:3000/yogo_data/edit/1
  #  edits data object 1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return [Model] Allows a user to edit a yogo project model data item's values
  #
  # @author Yogo Team
  #
  # @api public
  def edit
    @item = @model.get(params[:id])
  end

  # creates new data object
  #
  # @example http://localhost:3000/yogo_data/create
  #
  # @param [Hash] params
  # @option params [String] goober
  #
  # @return redirects to show data page if save was sucessful 
  #   else redirects to new
  #
  # @author Yogo Team
  #
  # @api public
  def create
    goober = "yogo_#{@project.namespace.underscore}_#{@model.name.demodulize.underscore}"

    @item = @model.new(params[goober].delete_if{|key,value| value.empty? })
    
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

  # updates a data object
  #
  # @example http://localhost:3000/yogo_data/update
  #
  # @param [Hash] params
  # @option params [String] goober
  # @option params [String] :id
  #
  # @return [Model, String] Updates a data item to the current yogo project model
  #
  # @author Yogo Team
  #
  # @api public
  def update
    @item = @model.get(params[:id])
    goober = "yogo_#{@project.namespace.underscore}_#{@model.name.demodulize.underscore}"
    @item.attributes = params[goober].delete_if{|key,value| value.empty? }
    @item.save
    redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
  end  

  # destroys a data object
  #
  # @example http://localhost:3000/yogo_data/destroy/1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return redirects to data index
  #
  # @author Yogo Team
  #
  # @api public
  def destroy
    @model.get(params[:id]).destroy!
    redirect_to project_yogo_data_index_url(@project, @model.name.demodulize)
  end

  # alows us to upload csv file to be processed into data
  #
  # @example http://localhost:3000/project/upload/1/
  #
  # @param [Hash] params
  # @option params [Hash] :upload
  #
  # @return [String] Accepts the upload of a CSV file
  #
  # @author Yogo Team
  #
  # @api public
  def upload
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
      else
        # Read the data in
        csv_data = FasterCSV.read(datafile.path)
        errors = @model.load_csv_data(csv_data)
        if errors.empty?
          flash[:notice] = "#{@model.name.demodulize} Data Successfully Uploaded."
        else
          @errors = errors
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
        end
      end
      respond_to do |format|
        format.html { redirect_to project_yogo_data_index_url(@project, @model.name.demodulize) }
      end
    end
  end

  # gets a histrogram from an attribute name
  #
  # @example http://localhost:3000/project/histogram_attribute
  #
  # @param [Hash] params
  # @option params [String] :attribute_name
  #
  # @return [Historgram] returns a histogram of Yogo navigational values 
  #
  # @author Yogo Team
  #
  # @api public
  def histogram_attribute
    ref_path, noop, ref_query = URI::split(request.referer)[5,3]

    @attribute_name = params[:attribute_name]

    if ref_query.nil?
      @histogram = Yogo::Navigation.values(@model, @attribute_name.to_sym)
    else
      #what an ugly way to make a query scope.
      query_options = ref_query.split('&').select{|r| !r.blank?}
      query_options.each do |qo|
        qo.match(/q\[(\w+)\]\[\]=(.+)/)
        attribute = $1
        condition = $2
        if @query_scope.nil?
          @query_scope = @model.all(attribute.to_sym => condition)
        else
          @query_scope = @query_scope & @model.all(attribute.to_sym => condition)
        end
      end
      @histogram = Yogo::Navigation.values(@query_scope, @attribute_name.to_sym)
    end

    
    respond_to do |wants|
      wants.html 
      wants.js { render :partial => 'histogram_attribute' }
    end
  end

  # gets an asset associated with an attribute
  #
  # @example http://localhost:3000/project/download_asset/:
  #
  # @param [Hash] params
  # @option params [String] :attribute_name
  #
  # @return [File Download] returns a mime-type and file to the browser of the asset requested
  #
  # @author Yogo Team
  #
  # @api public
  def download_asset    
    instance = @model.get(params[:id])
    @attribute_name = params[:attribute_name]
    filename = File.join(Rails.root, Yogo::Setting['asset_directory'], @model.asset_path, instance[@attribute_name])
    content_type = MIME::Types.type_for(filename)[0].content_type
    send_file filename, :type => content_type #, :x_sendfile => true # TODO: if we use lightd or Apache 2
  end
  
  # gets an asset associated with an attribute
  #
  # @example http://localhost:3000/project/:project_id/yogo_data/:id/show_asset/:attribute_name
  #
  # @param [Hash] params
  # @option params [String] :attribute_name
  #
  # @return [File Download] returns a mime-type and file to the browser of the asset requested
  #
  # @author Yogo Team
  #
  # @api public
  def show_asset    
    instance = @model.get(params[:id])
    @attribute_name = params[:attribute_name]
    filename = File.join(Rails.root, Yogo::Setting['asset_directory'], @model.asset_path, instance[@attribute_name])
    content_type = MIME::Types.type_for(filename)[0].content_type
    send_file filename, :type => content_type, :disposition => :inline #, :x_sendfile => true # TODO: if we use lightd or Apache 2
  end
  
  private
  
  ##
  # pulls model data into a CSV file format
  #
  # @return [File] Allows download of yogo project model data in CSV format
  #
  # @author Yogo Team
  #
  # @api private
  def download_csv
    send_data(@model.make_csv(true),
              :filename    => "#{@model.name.demodulize.tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end
  ##
  # returns a projects model
  #
  # @param [Hash] params
  # @option params [String] :project_id
  # @option params [String] :model_id
  #
  # @return [Model] returns a project's model
  #
  # @author Yogo Team
  #
  # @api private
  def find_parent_items
    @project = Project.get(params[:project_id])
    @model = @project.get_model(params[:model_id])
  end
end
