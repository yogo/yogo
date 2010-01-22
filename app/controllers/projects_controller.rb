require 'file_type_error'

class ProjectsController < ApplicationController

#  require_user :for => [ :show, :new, :create, :edit, :destroy, :update, :upload_csv]
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

  def upload_csv
    @project = Project.get(params[:id])
    
    if !params[:upload].nil?
      begin
        @project.process_csv(params[:upload]['datafile'])
        flash[:notice]  = "File uploaded succesfully."
      rescue FileTypeError => e
        flash[:error] = "File type #{params[:upload]['datafile'].content_type} not allowed"
      end
    else
       flash[:error] = "File upload area cannont be blank."
    end

    redirect_to project_url(@project)
  end
end