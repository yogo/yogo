class ProjectsController < ApplicationController

  def index
    @projects = Project.all
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
      flash[:error] = "Project \"#{@project.name}\" could not be created."
      render :action => new
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
      flash[:error] = "Project \"#{@project.name}\" could not be updated."
      render :action => edit
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
  
end