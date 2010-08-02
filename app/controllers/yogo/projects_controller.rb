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
    @_menu_partial = 'index_menu'

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
    search_scope = params[:search_scope]
    search_term = params[:search_term]
    if search_scope == 'everywhere' || params[:model_name].blank?
      @projects = Project.available.search(search_term)

      @proj_models = []
      Project.public.each do |project|
        @proj_models << [project, project.search_models(search_term).flatten ]
      end

      @proj_models_data = []
      Project.available.each do |project|
        project.models.each do |model|
          count = model.search(search_term).count
          @proj_models_data << [project, model, count] if count > 0
        end
      end

      respond_to do |format|
        format.html
      end

    else
      project = Project.get(params[:project_id])
      model = project.get_model(params[:model_name])
      respond_to do |format|
        format.html { redirect_to search_project_yogo_data_url(project, model, :search_term => search_term) }
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
    @_menu_partial = 'show_menu'

    if !Yogo::Setting[:local_only] && @project.is_private?
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
    if !Yogo::Setting[:local_only]
      flash[:error] = "You need to login first" unless logged_in?
      flash[:error] = "You do not have permission to create the project." unless current_user.has_permission?(:create_projects)
    end

    @project = Project.new(params[:project])

    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been created."
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

    if !Yogo::Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless @project.groups.users.empty? || current_user.has_permission?(:edit_project,@project)
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

    if !Yogo::Setting[:local_only]
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

    if !Yogo::Setting[:local_only]
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

    if !Yogo::Setting[:local_only]
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

    if !Yogo::Setting[:local_only] && (!logged_in?)
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
      Yogo::Setting[:example_project_loaded] = true
      redirect_to project_url(@project)
    else
      flash[:error] = "Example Project could not be created, so was not loaded."
      redirect_to root_url
    end
  end

end
