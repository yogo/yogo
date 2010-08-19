class His::CensorCodeCVsController < ApplicationController
  # GET /censor_code_cvs
  def index
    @censor_code_cvs = His::CensorCodeCV.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /censor_code_cvs/1
  def show
    @censor_code_cv = His::CensorCodeCV.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /censor_code_cvs/new
  def new
    @censor_code_cv = His::CensorCodeCV.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /censor_code_cvs/1/edit
  def edit
    @censor_code_cv = His::CensorCodeCV.get(params[:id])
  end

  # POST /censor_code_cvs
  def create
    @censor_code_cv = His::CensorCodeCV.new(params[:censor_code_cv])

    respond_to do |format|
      if @censor_code_cv.save
        flash[:notice] = 'His::CensorCodeCV was successfully created.'
        format.html { redirect_to(his_censor_code_c_v_path(@censor_code_cv.term)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /censor_code_cvs/1
  def update
    @censor_code_cv = His::CensorCodeCV.get(params[:id])

    respond_to do |format|
      if @censor_code_cv.update_attributes(params[:censor_code_cv])
        flash[:notice] = 'His::CensorCodeCV was successfully updated.'
        format.html { redirect_to(his_censor_code_c_v_path(@censor_code_cv.term)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end


end
