class Voeis::ApivsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'apivs',
            :route_instance_name => 'apiv',
            :collection_name => 'apivs',
            :instance_name => 'apiv',
            :resource_class => Voeis::Apiv


  # GET /variables/new
  def new
    if !params[:data_stream_ids].empty?
      @download_meta_array = Array.new
      params[:data_stream_ids].each do |data_stream_id|
        data_stream = parent.managed_repository{Voeis::DataStream.get(data_stream_id)}
        site = data_stream.sites.first
        @sensor_hash = Hash.new
        data_stream.data_stream_columns.all(:order => [:column_number.asc]).each do |data_col|
          @value_array= Array.new
          sensor = data_col.sensor_types.first
          
          if !sensor.nil?
            if !sensor.variables.empty?
            if !params[:variable_ids].nil?
              var = sensor.variables.first
            params[:variable_ids].each do |var_id|
              if var.id == var_id.to_i     
                if !params[:start_date].nil? && !params[:end_date].nil?     
                  sensor.sensor_values(:timestamp.gte => params[:start_date],:timestamp.lte => params[:end_date], :order => (:timestamp.asc)).each do |val|
                    @value_array << [val.timestamp, val.value]
                  end #end do val
                elsif !params[:hours].nil?
                  last_date = sensor.sensor_values.last(:order => [:timestamp.asc]).timestamp
                  start_date = (last_date.to_time - params[:hours].to_i.hours).to_datetime
                  sensor.sensor_values(:timestamp.gte => start_date, :order => (:timestamp.asc)).each do |val|
                    @value_array << [val.timestamp, val.value]
                  end #end do val
                end #end if
                @data_hash = Hash.new
                @data_hash[:data] = @value_array
                @sensor_meta_array = Array.new
                variable = sensor.variables.first
                @sensor_meta_array << [{:variable => variable.variable_name}, 
                                       {:units => Unit.get(variable.variable_units_id).units_abbreviation},
                                       @data_hash]
                @sensor_hash[sensor.name] = @sensor_meta_array
              end #end if
            end #end do var_id
          end # end if
        end # end if
          end #end if
        end #end do data col
        @download_meta_array << [{:site => site.name}, 
                                {:site_code => site.code}, 
                                {:lat => site.latitude}, 
                                {:longitude => site.longitude},
                                {:sensors => @sensor_hash}]
      end #end do data_stream
    end # end if
  # end
  respond_to do |format|
    format.json do
      format.html
      render :json => @download_meta_array, :callback => params[:jsoncallback]
    end
  end
  end
  
  #************Sites
  
  # create_site
  # API for creating a new site within in a project
  # 
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_site.json?name=example&code=example&latitude=45.232&longitude=-111.234&state=MT 
  #
  # @param [String] name the name of the site
  # @param [String] code the unique code for identifying the site
  # @param [Float] latitude the latitude coordinate of the site
  # @param [Float] longitude the longitude coordinate for the site
  # @param [String] state the two letter abbreviation for a US state
  #  
  # @author Sean Cleveland
  #
  def create_site
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.new(:name => params[:name], 
                                     :code => params[:code],
                                     :latitude => params[:latitude],
                                     :longitude => params[:longitude],
                                     :state => params[:state])#,
                                     #:country => params[:country])
      begin
       @site.save
      rescue
       puts @site = {:errors => @site.errors}
      end
    end
    respond_to do |format|
      format.json do
        format.html
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
    end
  end
  
  # get_site
  # API for getting a site
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_site.json?id=1
  #
  # @params[String] id the id of the site within the project
  #
  # @author Sean Cleveland
  #
  def get_site
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.get(params[:id])
    end
    respond_to do |format|
      format.html
      format.json do
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
    end
  end

  # get_all_sites
  # API for getting all the sites within in a project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_all_sites.json?
  # 
  # @author Sean Cleveland
  #
  def get_all_sites
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.all()
    end
    respond_to do |format|
      
      format.json do
        format.html
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
    end
  end
   
   #************Variables
   
   # create_variable
   # API for creating a new site within in a project
   # 
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_variable.json?variable_name=example&variable_code=example&speciation=unkown&sample_medium=surface water&state=MT 
   #
   # @param [String] variable_name the name of the variable - exists in variable_names_cv
   # @param [String] variable_code the unique code for identifying this variable
   # @param [String] speciation the speciation of the vairable - may be "unknown"
   #  
   # @author Sean Cleveland
   #
   def create_variable
     @variable = ""
     parent.managed_repository do
       @variable = Voeis::Variable.new(:variable_name => params[:variable_name], 
                                      :variable_code => params[:variable_code],
                                      :speciation => params[:speciation],
                                      :sample_medium => params[:sample_medium],
                                      :value_type => params[:value_tyep],
                                      :data_type => params[:data_type])
      begin
       @variable.save
      rescue
        puts @variable = {:errors => @variable.errors}
      end
     end
     respond_to do |format|
       format.json do
         format.html
         render :json => @variable.to_json, :callback => params[:jsoncallback]
       end
     end
   end
    

end