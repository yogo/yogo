class His::DataTypeCVsController < ApplicationController
  # GET /data_type_cvs
  def index
    @data_type_cvs = His::DataTypeCV.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /data_type_cvs/1
  def show
    @data_type_cv = His::DataTypeCV.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /data_type_cvs/new
  def new
    @data_type_cv = His::DataTypeCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /data_type_cvs/1/edit
  def edit
    @data_type_cv = His::DataTypeCV.get(params[:id])
  end

  # POST /data_type_cvs
  def create
    @data_type_cv = His::DataTypeCV.new(params[:data_type_cv])

    respond_to do |format|
      if @data_type_cv.save
        flash[:notice] = 'His::DataTypeCV was successfully created.'
        format.html { redirect_to(his_data_type_c_v_path(@data_type_cv.term)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /data_type_cvs/1
  def update
    @data_type_cv = His::DataTypeCV.get(params[:id])

    respond_to do |format|
      if @data_type_cv.update_attributes(params[:data_type_cv])
        flash[:notice] = 'His::DataTypeCV was successfully updated.'
        format.html { redirect_to(his_data_type_c_v_path(@data_type_cv.term)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
