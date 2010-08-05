# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < ApplicationController

  # Show all the projects
  #
  # @example
  #   get /projects
  #
  # @return [Array] Retrives all project and passes them to the view
  #
  # @author Yogo Team
  #
  # @api public
  def index
    @projects = Project.available.paginate(:page => params[:page], :per_page => 5)

     respond_to do |format|
        format.html
      end
  end

  # Find a project or projects and show the result
  #
  # @example
  #   get /projects/search?q=search-term
  #
  # @return [Model] searches for data across all project all models all content of models
  #
  # @author Yogo Team
  #
  # @api public
  def search
    @search_scope = params[:search_scope]
    @search_term = params[:search_term]

    # Example
    # if current_user.authorized?(:project_search)
    # end

    if @search_scope == 'everywhere' || params[:model_name].blank?
      @projects = Project.available.search(@search_term)

      @proj_models = []
      Project.available.each do |project|
        @proj_models << [project, project.search_models(@search_term).flatten ]
      end

      @proj_models_data = []
      Project.available.each do |project|
        project.models.each do |model|
          count = model.search(@search_term).count
          @proj_models_data << [project, model, count] if count > 0
        end
      end

      respond_to do |format|
        format.html {
          if @proj_models_data.length == 1
            redirect_to(search_project_yogo_data_url(@proj_models_data[0][0],
                                                     @proj_models_data[0][1],
                                                     :search_term => @search_term))
          end
        }
      end

    else
      project = Project.get(params[:project_id])
      model = project.get_model(params[:model_name])
      respond_to do |format|
        format.html {
          redirect_to search_project_yogo_data_url(project, model, :search_term => @search_term)
        }
      end
    end

  end

  ##
  # Shows a project
  #
  # @example
  #   get /projects/1 # Returnes project with an id of 1
  #
  # @return [Object] returns a web page displaying a project
  #
  # @author Yogo Team
  #
  # @api public
  def show
    @project = Project.get(params[:id])

    if !Setting[:local_only] && @project.is_private?
      raise AuthenticationError if !logged_in?
      raise AuthorizationError  if !current_user.is_in_project?(@project)
    end

    @models = @project.models
    @sidebar = true

    respond_to do |format|
      format.html
    end
  end

  ##
  # Returns a form for creating a new project
  #
  # @example
  #   get /projects/new
  #
  # @return [Object] returns an empty project
  #
  # @author Yogo Team
  #
  # @api public
  def new
    @project = Project.new

    respond_to do |format|
      format.html
    end

  end

  ##
  # Creates a new project based on the attributes
  #
  # @example
  #   post /projects
  #
  # @param [Hash] params
  # @option params [Hash] :project this is the attributes of a project
  #
  # @return if the project saves correctly it redirects to show project
  #  else it redirects to new project page
  #
  # @author Yogo Team
  #
  # @api public
  def create
    if !Setting[:local_only]
      flash[:error] = "You need to login first" unless logged_in?
      flash[:error] = "You do not have permission to create the project." unless current_user.has_permission?(:create_projects)
    end

    @project = Project.new(params[:project])

    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been created."
        #Check to be sure the default VOEIS project is loaded - create it if it doesn't exist
        # if Project.first(:name => "VOEIS").nil?
        #   def_project = Project.new()
        #   def_project.name = "VOEIS"
        #   def_project.description = "The Default VOEIS Project and Repository"
        #   def_project.save
        #   puts odm_contents = Dir.new("dist/odm").entries
        #   odm_contents.each do |content|
        #     puts content.to_s + "before"
        #     if !content.to_s.index('.csv').nil?
        #       puts content.to_s
        #       def_project.process_csv('dist/odm/' + content.to_s, content.to_s.gsub(".csv",""))
        #     end
        #   end
        # end
        # puts voeis_contents = Dir.new("dist/voeis_default").entries
        # voeis_contents.each do |content|
        #   puts content.to_s + "before"
        #   if !content.to_s.index('.csv').nil?
        #     puts content.to_s
        #     @project.process_csv('dist/voeis_default/' + content.to_s, content.to_s.gsub(".csv",""))
        #   end
        # end
      redirect_to projects_url
    else
      flash[:error] = "Project could not be created."
      redirect_to projects_url
    end
  end

  ##
  # load project for editing
  #
  # @example
  #  get /projects/1/edit # edits project with an id of 1
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Object] returns a project
  #
  # @author Yogo Team
  #
  # @api public
  def edit
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless @project.roles.users.empty? || current_user.has_permission?(:edit_project,@project)
    end

    respond_to do |format|
      format.html
    end
  end

  ##
  # Updates project with new values
  #
  # @example
  #   put /projects/1
  #
  # @param [Hash] params
  # @option params [String]:id
  # @option params [Hash] :project
  #
  # @return if the project saves correctly it redirects to show project
  #  else it redirects to edit project page
  #
  # @author Yogo Team
  #
  # @api public
  def update
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless current_user.has_permission?(:edit_project,@project)
    end

    params[:project].delete(:name) if params.has_key?(:project)
    @project.attributes = params[:project]
    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been updated."
      redirect_to projects_url
    else
      flash[:error] = "Project could not be updated."
      render( :action => :edit )
    end
  end

  ##
  # deletes a project
  #
  # @example
  #   destroy /projects/1
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return no matter what it redirects to
  #  project index page
  #
  # @author Yogo Team
  #
  # @api public
  def destroy
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      flash[:error] = "You need to login first" unless logged_in?
      # We don't know how to check for this permission yet.
      #flash[:error] = "You do not have permission to delete the project." unless current_user.has_permission?(:delete_project, @project)
    end

    if @project.destroy
      flash[:notice] = "Project \"#{@project.name}\" has been destroyed."
    else
      flash[:error] = "Project \"#{@project.name}\" could not be destroyed."
    end
    redirect_to projects_url
  end

  # Create a new dataset on the project with a CSV file
  #
  # @example
  #  post /projects/upload/1 # with a CSV file
  #
  # @param [Hash] params
  # @option params [String]:id
  # @option params [Hash] :upload
  #
  # @return [] always redirects to showproject
  #
  # @author Yogo Team
  #
  # @api public
  def upload
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless current_user.has_permission?(:edit_project,@project)
    end

    if !params[:upload].nil?
      datafile = params[:upload]['datafile']

      if !['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        #redirect_to project_url(@project)
      else
        class_name = File.basename(datafile.original_filename, ".csv").singularize.camelcase

        errors =  @project.process_csv(datafile.path, class_name)

        if errors.empty?
          flash[:notice]  = "Spreadsheet imported succesfully."
        else
          flash[:error] = errors.join("\n")
        end
      end

    else
       flash[:error] = "Spreadsheet import error, please try the upload again."
    end

    redirect_to project_url(@project)
  end

  # loads example project and models in Yogo
  #
  # @example
  #   get /projects/loadexample
  #
  # @return redirects to project index page
  #
  # @todo Figure out how this should act when in server mode.
  #
  # @author Yogo Team
  #
  # @api public
  def loadexample
    # Load the cercal db from CSV

    if !Setting[:local_only] && (!logged_in?)
      raise AuthenticationError
    end

    @project = Project.create(:name => "Cricket Cercal System DB")
    if @project.valid?
      errors = @project.process_csv(Rails.root.join("dist", "example_data", "cercaldb", "cells.csv"), "Cell")
      if errors.empty?
        flash[:notice]  = "Example Project imported succesfully."
      else
        flash[:error] = errors.join("\n")
      end
      Setting[:example_project_loaded] = true
      redirect_to project_url(@project)
    else
      flash[:error] = "Example Project could not be created, so was not loaded."
      redirect_to root_url
    end
  end

  def add_site
    @project = Project.get(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def add_stream
    @project = Project.get(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  # alows us to upload csv file to be processed into data
  #
  # @example http://localhost:3000/project/upload_stream/1/
  #
  # @param [Hash] params
  # @option params [Hash] :upload
  #
  # @return [String] Accepts the upload of a CSV file
  #
  # @author Yogo Team
  #
  # @api public
  def upload_stream
    @project = Project.first(:id => params[:project_id])
    @variables = Variable.all
    @sites = Site.all
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        redirect_to(:controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]})
      else

        # Read the logger file header
        @header_info = parse_logger_csv_header(datafile.path)
        if @header_info.empty?
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
          #redirect_to :controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]}
        end
      end
      respond_to do |format|
        format.html
      end
    end
  end
  
  def create_stream
    #create and save new DataStream
    data_stream = DataStream.new(:name => params[:data_stream_name], 
                                 :description => params[:data_stream_description],
                                 :filename => params[:datafile],
                                 :project_id => params[:project_id])
    data_stream.sites << Site.first(:id => params[:site])
    data_stream.save
    
    #add data_stream to site
    site = Site.first(:id => params[:site])
    site.data_streams << data_stream
    site.save
    
    #create DataStreamColumns
    (0..params[:rows]-1).each do |i|
      #create the Timestamp column
      if i == params[:timestamp]
        data_stream_column = DataStreamColumn.new(:column_number => i, 
                                                  :name => params[:header][i][:name], 
                                                  :type =>"Timestamp")
        data_stream_column.save
      else
        data_stream_column = DataStreamColumn.new(:column_number => i, 
                                                  :name => params[:header][i][:name],
                                                  :original_var => params[:header][i][:variable],
                                                  :type => params[:header][i][:type])
        data_stream_column.variables << Variable.first(:id => params[:variable])
        data_stream_column.data_streams << data_stream
        data_stream_column.save
        data_stream.data_stream_columns << data_stream_column
        data_stream.save 
      end
    end
    # process csv data and store datavalues
    # 
    # 
  end
  
  # parse the header of a logger file
  #
  # @example parse_logger_csv_header("filename")
  #
  # @param [String] csv_file
  #
  # @return [Array] an array whose elements are a hash
  #
  # @author Yogo Team
  #
  # @api public
  def parse_logger_csv_header(csv_file)
    require "yogo/model/csv"
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)

    #look at the first hour lines - 
    #line 0 is a description -so skip that one
    #line 1 is the variable names
    #line 2 is the units
    #line 3 is the type
    #store the variable,unit and type for a column as a hash in an array
    header_data=Array.new
    (0..csv_data[1].size-1).each do |i|
      item_hash = Hash.new
      item_hash["variable"] = csv_data[1][i]
      item_hash["unit"] = csv_data[2][i]
      item_hash["type"] = csv_data[3][i]
      header_data << item_hash
    end
    
    header_data
  end
end
