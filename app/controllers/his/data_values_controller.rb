
class His::DataValuesController < ApplicationController
  # GET /data_values
  # GET /data_values.xml
  def index
    
    @data_values = His::DataValues.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /data_values/1
  # GET /data_values/1.xml
  def show
    @data_value = His::DataValues.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /data_values/new
  # GET /data_values/new.xml
  def new
    @data_value = His::DataValues.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /data_values/1/edit
  def edit
    @data_value = His::DataValues.get(params[:id])
  end

  # POST /data_values
  # POST /data_values.xml
  def create
    @data_value = His::DataValues.new(params[:new_data_value])

    respond_to do |format|
      if @data_value.save
        flash[:notice] = 'His::DataValues was successfully created.'
        format.html { redirect_to(raw_data_value_path(@data_value.id)) }
      else
        flash[:warning] = "WTF Seriouslyfacebo"
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /data_values/1
  # PUT /data_values/1.xml
  def update
    @data_value = His::DataValues.get(params[:id])

    respond_to do |format|
      if @data_value.update_attributes(params[:data_value])
        flash[:notice] = 'His::DataValues was successfully updated.'
        format.html { redirect_to(raw_data_value_path(@data_value.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /data_values/1
  # DELETE /data_values/1.xml
  def destroy
    @data_value = His::DataValues.get(params[:id])
    @data_value.destroy

    respond_to do |format|
      format.html { redirect_to(raw_data_type_c_vs_url) }
    end
  end
end
