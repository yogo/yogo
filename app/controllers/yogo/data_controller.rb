# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# Functionality for CRUD of data within a yogo project's model
# Additionally upload and download of data via CSV is provided
#
class Yogo::DataController < ApplicationController
  before_filter :find_parent_items, :check_project_authorization, :show_sidebar

  ##
  # 10 data objects per page are displayed
  #
  # @example 
  #   get /project/1/yogo_data
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
    
    @data = @query.paginate(:page => params[:page], :per_page => Project.per_page)
    respond_to do |format|
      format.html { @no_blueprint = true }
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
    @search_term = params[:search_term]

    @query = @model.search(@search_term)
    @data = @query.paginate(:page => params[:page], :per_page => Project.per_page)
    respond_to do |format|
      format.html { render( :action => :index) }
      format.json {  @data = @query.all, render( :json => @data.to_json )}
      format.csv  { download_csv }
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
        flash[:notice_link] = project_yogo_data_path(@project, @model.name.demodulize, @item)
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

    respond_to do |format|
      if @item.save
        format.html { redirect_to project_yogo_data_index_url(@project, @model.name.demodulize) }
      else
        format.html { render(:action => 'edit') }
      end
    end
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
    @model.get(params[:id]).destroy
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
        errors = @model.load_csv_data(datafile.path)
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
    property = @model.properties[params[:attribute_name].to_sym]
    instance = @model.get(params[:id])
    filename = instance.send(property.name).path
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
    property = @model.properties[params[:attribute_name].to_sym]
    instance = @model.get(params[:id])
    filename = instance.send(property.name).path
    content_type = MIME::Types.type_for(filename)[0].content_type
    send_file filename, :type => content_type, :disposition => 'inline' #, :x_sendfile => true # TODO: if we use lightd or Apache 2
  end
  
  private
  
  # pulls model data into a CSV file format
  #
  # @return [File] Allows download of yogo project model data in CSV format
  #
  # @author Yogo Team
  #
  # @api private
  def download_csv
    csv_data = ''
    @query.all.each{|i| csv_data << i.to_yogo_csv + "\n" }
    send_data(@model.to_yogo_csv + csv_data,
              :filename    => "#{@model.name.demodulize.tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end
  
  # Returns a projects model
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
  
  ##
  # Checks to see if the current user is authorized to perform the current action
  # @return [nil]
  # @raise Execption
  # @author lamb
  # @api private
  def check_project_authorization
    if !Setting[:local_only]
      raise AuthenticationError if @project.is_private? && !logged_in?
      action = request.parameters["action"]
      if ['index', 'show', 'search', 'download_asset', 'show_asset'].include?(action)
        raise AuthorizationError unless !@project.is_private? || (logged_in? && current_user.is_in_project?(@project))
      else
        permission = :edit_model_data if ["new", 'create', 'edit', 'update'].include?(action)
        permission = :delete_model_data if ['destroy'].include?(action)
        raise AuthenticationError if !logged_in?
        raise AuthorizationError  if !current_user.has_permission?(permission,@project)
      end
    end
  end
end
