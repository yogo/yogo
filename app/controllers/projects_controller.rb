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
  # @return [ Array ] Retrives all project and passes them to the veiw
  # 
  # @api public
  # 
  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 5)
  end
  
  ##
  # Find a project or projects and show the result
  # 
  # @return [Model] searches for data across all project all models all content of models
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

  def show
    @project = Project.get(params[:id])
    @models = @project.models
  end

  def new
    @project = Project.new
  end

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

  def edit
    @project = Project.get(params[:id])
  end

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

  def destroy
    @project = Project.get(params[:id])
    if @project.destroy
      flash[:notice] = "Project \"#{@project.name}\" has been destroyed."
    else
      flash[:error] = "Project \"#{@project.name}\" could not be destroyed."
    end
    redirect_to projects_url
  end

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
  
  def loadexample
    # Load the project and data 
    Yogo::Loader.load(:example, "Example Project")
    redirect_to :back
  end
  
  def list_models
    @project = Project.get(params[:id])
    @models = @project.models
    
    respond_to do |wants|
      wants.html
      wants.js  { render(:partial => 'list_models', :locals => { :models => @models, :project => @project }) }
    end
  end
end