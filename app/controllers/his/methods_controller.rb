class His::MethodsController < ApplicationController
  # GET /methods
  def index
    @methods = His::Methods.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /methods/1
  def show
    @method = His::Methods.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /methods/new
  def new
    @method = His::Methods.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /methods/1/edit
  def edit
    @method = His::Methods.get(params[:id])
  end

  # POST /methods
  def create
    @method = His::Methods.new(params[:method])

    respond_to do |format|
      if @method.save
        flash[:notice] = 'His::Methods was successfully created.'
        format.html { redirect_to(his_method_path(@method.id)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /methods/1
  def update
    @method = His::Methods.get(params[:method])

    respond_to do |format|
      if @method.update_attributes(params[:id])
        flash[:notice] = 'His::Methods was successfully updated.'
        format.html { redirect_to(his_method_path(@method.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
