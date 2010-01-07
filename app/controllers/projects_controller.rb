require 'file_type_error'

class ProjectsController < ApplicationController

  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @project = Project.get(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    @project.yogo_collection = Yogo::Collection.create(:project_id => @project.id)
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
    
    begin
      @project.process_csv(params[:upload]['datafile'])
      puts "Called process_csv and it worked"
      flash[:notice]  = "File uploaded succesfully."
    rescue FileTypeError => e
      puts "File error"
      flash[:warning] = "File type #{params[:upload]['datafile'].content_type} not allowed"
    # rescue => e
    #   puts "unknown error"
    #   puts e.inspect
    #   flash[:warning] = "There was an error uploading your file."
    end
    puts flash.inspect
    puts "after begin block"
    redirect_to project_url(@project)
  end
end