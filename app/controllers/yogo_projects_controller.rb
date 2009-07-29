class YogoProjectsController < ApplicationController
  # GET /yogo_projects
  # GET /yogo_projects.xml
  def index
    @yogo_projects = YogoProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @yogo_projects }
    end
  end

  # GET /yogo_projects/1
  # GET /yogo_projects/1.xml
  def show
    @yogo_project = YogoProject.get(params[:id])

    puts #{@yogo_project.inspect}

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @yogo_project }
    end
  end

  # GET /yogo_projects/new
  # GET /yogo_projects/new.xml
  def new
    @yogo_project = YogoProject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @yogo_project }
    end
  end

  # GET /yogo_projects/1/edit
  def edit
    @yogo_project = YogoProject.get(params[:id])
  end

  # POST /yogo_projects
  # POST /yogo_projects.xml
  def create
    @yogo_project = YogoProject.new(params[:yogo_project])

    respond_to do |format|
      if @yogo_project.save
        flash[:notice] = 'YogoProject was successfully created.'
        format.html { redirect_to(yogo_project_path @yogo_project.id) }
        format.xml  { render :xml => @yogo_project, :status => :created, :location => @yogo_project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @yogo_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /yogo_projects/1
  # PUT /yogo_projects/1.xml
  def update
    @yogo_project = YogoProject.get(params[:id])

    respond_to do |format|
      if @yogo_project.update_attributes(params[:yogo_project])
        flash[:notice] = 'YogoProject was successfully updated.'
        format.html { redirect_to(@yogo_project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @yogo_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /yogo_projects/1
  # DELETE /yogo_projects/1.xml
  def destroy
    @yogo_project = YogoProject.get(params[:id])
    @yogo_project.destroy

    respond_to do |format|
      format.html { redirect_to(yogo_projects_url) }
      format.xml  { head :ok }
    end
  end
end
