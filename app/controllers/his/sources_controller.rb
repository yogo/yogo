class His::SourcesController < ApplicationController
  # GET /sources
  def index
    @sources = His::Sources.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sources/1
  def show
    @source = His::Sources.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /sources/new
  def new
    @source = His::Sources.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /sources/1/edit
  def edit
    @source = His::Sources.get(params[:id])
  end

  # POST /sources
  def create
    @source = His::Sources.new(params[:source])

    respond_to do |format|
      if @source.save
        flash[:notice] = 'His::Sources was successfully created.'
        format.html { (redirect_to(his_source_path( @source.id))) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /sources/1
  def update
    @source = His::Sources.get(params[:source])

    respond_to do |format|
      if @source.update_attributes(params[:id])
        flash[:notice] = 'His::Sources was successfully updated.'
        format.html { redirect_to(his_source_path( @source.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
