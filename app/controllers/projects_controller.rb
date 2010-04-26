# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.
#

class ProjectsController < ApplicationController
  
  ##
  # Show all the projects
  #
  # @example http://localhost:3000/project
  #
  # @return [ Array ] Retrives all project and passes them to the veiw
  #
  # @author Yogo Team
  #
  # @api public
  # 
  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 5)
  end
  
  ##
  # Find a project or projects and show the result
  #
  # @example http://localhost:3000/project/search
  #
  # @return [Model] searches for data across all project all models all content of models
  #
  # @author Yogo Team
  #
  # @api public
  # 
  def search
    search_term = params[:search_term]
    
    @projects = Project.search(search_term)

    @proj_models = []
    Project.all.each do |project|
      @proj_models << [project, project.search_models(search_term).flatten ]
    end

    @proj_models_data = []
    Project.all.each do |project|
      project.models.each do |model|
        count = model.search(search_term).count
        @proj_models_data << [project, model, count] if count > 0
      end
    end
    
    respond_to do |format|
      format.html
    end

  end

  ##
  # Shows a project
  #
  # @example http://localhost:3000/project/1
  #  shows project with an id of 1
  #
  # @return [Object] returns a web page displaying a project
  #
  # @author Yogo Team
  #
  # @api public
  #
  def show
    @project = Project.get(params[:id])
    @models = @project.models
  end

  ##
  # Creates a new project
  #
  # @example http://localhost:3000/project/new
  #
  # @return [Object] returns an empty project
  #
  # @author Yogo Team
  #
  # @api public
  #
  def new
    @project = Project.new
  end
  
  ##
  # Saves attributes of new project
  #
  # @example http://localhost:3000/project/create/
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
  #
  def create
    @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been created."
      redirect_to projects_url
    else
      flash[:error] = "Project could not be created."
      render :action => :new
    end
  end

  ##
  # load project for editing
  #
  # @example http://localhost:3000/project/edit/1/
  #  edits project with an id of 1
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Object] returns a project
  #
  # @author Yogo Team
  #
  # @api public
  #
  def edit
    @project = Project.get(params[:id])
  end

  ##
  # load project for editing
  #
  # @example http://localhost:3000/project/update/
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
  #
  def update
    @project = Project.get(params[:id])
    @project.attributes = params[:project]
    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been updated."
      redirect_to projects_url
    else
      flash[:error] = "Project could not be updated."
      render :action => :edit
    end
  end

  ##
  # deletes a project
  #
  # @example http://localhost:3000/project/destroy/1
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
  #
  def destroy
    @project = Project.get(params[:id])
    if @project.destroy
      flash[:notice] = "Project \"#{@project.name}\" has been destroyed."
    else
      flash[:error] = "Project \"#{@project.name}\" could not be destroyed."
    end
    redirect_to projects_url
  end

  ##
  # alows us to upload csv file to be processed into a model
  #
  # @example http://localhost:3000/project/upload/1/
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
  #
  def upload
    @project = Project.get(params[:id])
    
    if !params[:upload].nil?
      datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        #redirect_to project_url(@project)
      else
        class_name = File.basename(datafile.original_filename, ".csv").singularize.camelcase
        
         errors =  @project.process_csv(datafile.path, class_name)
        
        if errors.empty?
          flash[:notice]  = "File uploaded succesfully."
        else
          flash[:error] = errors.join("\n")
        end
      end
    else
       flash[:error] = "File upload area cannont be blank."
    end
    
    redirect_to project_url(@project)
  end
  ##
  # loads example project and models in Yogo
  #
  # @example http://localhost:3000/project/loadexample
  #
  # @return redirects to project index page
  #
  # @author Yogo Team
  #
  # @api public
  #
  def loadexample
    # Load the project and data 
    #Yogo::Loader.load(:example, "Example Project")
        
    # Load the cercal db from CSV
    @project = Project.create(:name => "Cricket Cercal System DB")
    errors = @project.process_csv(Rails.root.join("dist", "example_data", "cercaldb", "cells.csv"), "Cell")
    if errors.empty?
      flash[:notice]  = "File uploaded succesfully."
    else
      flash[:error] = errors.join("\n")
    end
    redirect_to :back
  end
  ##
  # lists all models for a selected project
  #
  # @example http://localhost:3000/project/1/
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Page] returns page with a list of models
  #
  # @author Yogo Team
  #
  # @api public
  #
  def list_models
    @project = Project.get(params[:id])
    @models = @project.models
    
    respond_to do |wants|
      wants.html
      wants.js  { render(:partial => 'list_models', :locals => { :models => @models, :project => @project }) }
    end
  end
end