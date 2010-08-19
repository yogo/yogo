class His::SitesController < ApplicationController
  # GET /sites
  def index
    @sites = His::Sites.all
    debugger
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sites/1
  def show
    @site = His::Sites.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /sites/new
  def new
    @site = His::Sites.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /sites/1/edit
  def edit
    @site = His::Sites.get(params[:id])
  end

  # POST /sites
  def create
    @site = His::Sites.new(params[:site])

    respond_to do |format|
      if @site.save
        flash[:notice] = 'His::Sites was successfully created.'
        format.html { redirect_to(his_site_path(@site.id)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /sites/1
  def update
    @site = His::Sites.get(params[:site])

    respond_to do |format|
      if @site.update_attributes(params[:id])
        flash[:notice] = 'His::Sites was successfully updated.'
        format.html { redirect_to(his_site_path(@site.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
