class ProjectsController < ApplicationController

  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 5)
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
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        redirect_to project_url(@project)
      end
      # Check filename for .csv 
      @project.process_csv(datafile)
      flash[:notice]  = "File uploaded succesfully."
    else
       flash[:error] = "File upload area cannont be blank."
    end
    
    redirect_to projects_url
  end
  
  def rereflect
    DataMapper::Reflection.reflect(:yogo)
    redirect_to projects_url
  end
  
  def loadexample
    # Load the project and data 
    Yogo::Loader.load(:example, "Example Project")
    redirect_to :back
  end
end