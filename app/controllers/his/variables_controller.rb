class His::VariablesController < ApplicationController
  # GET /variables
  def index
    @variables = His::Variable.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /variables/1
  def show
    @variable = His::Variable.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /variables/new
  def new
    @variable = His::Variable.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /variables/1/edit
  def edit
    @variable = His::Variable.get(params[:id])
  end

  # POST /variables
  def create
    @variable = His::Variable.new(params[:variable])

    respond_to do |format|
      if @variable.save
        flash[:notice] = 'His::Variable was successfully created.'
        format.html { (redirect_to(his_variable_path( @variable.id))) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /variables/1
  def update
    @variable = His::Variable.get(params[:variable])

    respond_to do |format|
      if @variable.update_attributes(params[:id])
        flash[:notice] = 'His::Variable was successfully updated.'
        format.html { redirect_to(his_variable_path( @variable.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
