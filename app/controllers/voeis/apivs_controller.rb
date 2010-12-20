class Voeis::ApivsController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'apivs',
            :route_instance_name => 'apiv',
            :collection_name => 'apivs',
            :instance_name => 'apiv',
            :resource_class => Voeis::Apiv


  # # GET /variables/new
  # def new
  #   if !params[:data_stream_ids].empty?
  #     @download_meta_array = Array.new
  #     params[:data_stream_ids].each do |data_stream_id|
  #       data_stream = parent.managed_repository{Voeis::DataStream.get(data_stream_id)}
  #       site = data_stream.sites.first
  #       @sensor_hash = Hash.new
  #       data_stream.data_stream_columns.all(:order => [:column_number.asc]).each do |data_col|
  #         @value_array= Array.new
  #         sensor = data_col.sensor_types.first
  #         
  #         if !sensor.nil?
  #           if !sensor.variables.empty?
  #           if !params[:variable_ids].nil?
  #             var = sensor.variables.first
  #           params[:variable_ids].each do |var_id|
  #             if var.id == var_id.to_i     
  #               if !params[:start_date].nil? && !params[:end_date].nil?     
  #                 sensor.sensor_values(:timestamp.gte => params[:start_date],:timestamp.lte => params[:end_date], :order => (:timestamp.asc)).each do |val|
  #                   @value_array << [val.timestamp, val.value]
  #                 end #end do val
  #               elsif !params[:hours].nil?
  #                 last_date = sensor.sensor_values.last(:order => [:timestamp.asc]).timestamp
  #                 start_date = (last_date.to_time - params[:hours].to_i.hours).to_datetime
  #                 sensor.sensor_values(:timestamp.gte => start_date, :order => (:timestamp.asc)).each do |val|
  #                   @value_array << [val.timestamp, val.value]
  #                 end #end do val
  #               end #end if
  #               @data_hash = Hash.new
  #               @data_hash[:data] = @value_array
  #               @sensor_meta_array = Array.new
  #               variable = sensor.variables.first
  #               @sensor_meta_array << [{:variable => variable.variable_name}, 
  #                                      {:units => Unit.get(variable.variable_units_id).units_abbreviation},
  #                                      @data_hash]
  #               @sensor_hash[sensor.name] = @sensor_meta_array
  #             end #end if
  #           end #end do var_id
  #         end # end if
  #       end # end if
  #         end #end if
  #       end #end do data col
  #       @download_meta_array << [{:site => site.name}, 
  #                               {:site_code => site.code}, 
  #                               {:lat => site.latitude}, 
  #                               {:longitude => site.longitude},
  #                               {:sensors => @sensor_hash}]
  #     end #end do data_stream
  #   end # end if
  # # end
  # respond_to do |format|
  #   format.json do
  #     format.html
  #     render :json => @download_meta_array, :callback => params[:jsoncallback]
  #   end
  # end
  # end
  
  
  #*************DataStreams
  # 
  # curl -F datafile=@NFork_tail.csv -F data_template_id=4 -F api_key=e79b135dcfeb6699bbaa6c9ba9c1d0fc474d7adb755fa215446c398cae057adf http://voeis.msu.montana.edu/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80//apivs/upload_logger_data.json?
  # curl -F datafile=@YB_Hill.csv -F data_template_id=26 http://localhost:3000/projects/a459c38c-f288-11df-b176-6e9ffb75bc80/apivs/upload_logger_data.json?api_key=3b62ef7eda48955abc77a7647b4874e543edd7ffc2bb672a40215c8da51f6d09
  
  # 3b62ef7eda48955abc77a7647b4874e543edd7ffc2bb672a40215c8da51f6d09
  # 
  # curl -F datafile=@Next100-sean.csv -F data_template_id=22 -F api_key=3b62ef7eda48955abc77a7647b4874e543edd7ffc2bb672a40215c8da51f6d09 http://voeis.msu.montana.edu/projects/a459c38c-f288-11df-b176-6e9ffb75bc80/apivs/upload_logger_data.json?
  # 
  # curl -F datafile=@CR1000_BigSky_Weather_small.dat -F data_template_id=1 http://localhost:3000/projects/18402e48-f113-11df-9550-6e9ffb75bc80/apivs/upload_logger_data?api_key=2ac150bed4cfa21320d6f37cc6f007b807c603b6c8c33b6ba5a7db92ca821f35
  
  # curl -F datafile=@CR1000_BigSky_Weather_small.dat -F data_template_id=1 http://localhost:3000/projects/a4c62666-f26b-11df-b8fe-002500d43ea0/apivs/upload_logger_data?api_key=2ac150bed4cfa21320d6f37cc6f007b807c603b6c8c33b6ba5a7db92ca821f35
  
  # alows user to upload csv file to be processed into data
  # this requires that a datastream has already been created
  # to parse this file.  Can return json or xml as specified
  #
  # @example
  # curl -F datafile=@CR1000_2_BigSky_NFork_small.dat -F data_template_id=1 http://localhost:4000/projects/fbf20340-af15-11df-80e4-002500d43ea0/apivs/upload_logger_data.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7
  #
  #
  # @param [File] :datafile csv file to store
  # @param [Integer] :data_template_id the id of the data stream used to parse a file
  #
  # @return [String] :success or :error message
  # @return [Integer] :total_records_saved - the total number of records saved to Voeis
  # @return [Integer] :total_rows_parsed - the total number of rows successfully parsed
  # @return [String] :last_record  - the last record saved
  #
  # @author Sean Cleveland
  #
  # @api public
  def upload_logger_data 
    parent.managed_repository do
        first_row = Array.new
        flash_error = Hash.new
        name = Time.now.to_s + params[:datafile].original_filename 
        directory = "temp_data"
        @new_file = File.join(directory,name)
        File.open(@new_file, "wb"){ |f| f.write(params['datafile'].read)}
        begin 
            data_stream_template = Voeis::DataStream.get(params[:data_template_id].to_i)
            start_line = data_stream_template.start_line
            csv = CSV.open(@new_file, "r")
            (0..start_line).each do
              first_row = csv.readline
            end
            csv.close()
            path = File.dirname(@new_file)
          if first_row.count == data_stream_template.data_stream_columns.count
            flash_error = flash_error.merge(parent.managed_repository{Voeis::SensorValue.parse_logger_csv(@new_file, data_stream_template.id, data_stream_template.sites.first.id)})
          else
            #the file does not match the data_templates number of columns
            flash_error[:error] = "File does not match the data_templates number of columns."
            logger.info {"File does not match the data_templates number of columns."}
          end
        rescue   Exception => e
            logger.info {e.to_s}
          #problem parsing file
          flash_error[:error] = "There was a problem parsing this file."
          logger.info {"There was a problem parsing this file."}
        end
      #parent.publish_his
      respond_to do |format|
        if params.has_key?(:api_key)
          format.json
        end
        if flash_error[:error].nil?
          flash_error[:success] = "File was parsed succesfully."
          #flash_error = flash_error.merge({:last_record => data_stream_template.data_stream_columns.sensor_types.sensor_values.last(:order =>[:id.asc]).as_json}) 
        end
        format.json do
          render :json => flash_error.to_json, :callback => params[:jsoncallback]
        end
        format.xml do
          render :xml => flash_error.to_xml
        end
      end
    end
  end
  # get_project_data_templates
  # API for getting a list of the data_templates within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_data_templates.json?
  #
  # @params[String] id the id of the site within the project
  #
  # @author Sean Cleveland
  #
  # @return [JSON String] an array of data_templates that exist for the project and each ones properties and values
  # 
  # @api public
  def get_project_data_templates
   @dts = ""
   parent.managed_repository do
     @dts= Voeis::DataStream.all
   end
   respond_to do |format|
     format.json do
       render :json => @dts.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @dts.to_xml
     end
   end
  end
  
  #************Sites
  
  # create_project_site
  # API for creating a new site within in a project
  # 
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_site.json?name=example&code=example&latitude=45.232&longitude=-111.234&state=MT 
  #
  # @param [String] name the name of the site
  # @param [String] code the unique code for identifying the site
  # @param [Float] latitude the latitude coordinate of the site
  # @param [Float] longitude the longitude coordinate for the site
  # @param [String] state the two letter abbreviation for a US state
  #  
  # @author Sean Cleveland
  #
  # @api public
  def create_project_site
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
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @site.to_xml
      end
    end
  end
  
  
  # update_project_site
  # API for updating a site within in a project
  # 
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/update_project_site.json?name=example&code=example&latitude=45.232&longitude=-111.234&state=MT 
  #
  # @param [Integer] id the id of the site
  # @param [String] name the name of the site - <optional>
  # @param [String] code the unique code for identifying the site - <optional>
  # @param [Float] latitude the latitude coordinate of the site - <optional>
  # @param [Float] longitude the longitude coordinate for the site - <optional>
  # @param [String] state the two letter abbreviation for a US state - <optional>
  #  
  # @author Sean Cleveland
  #
  # @api public
  def update_project_site
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.get(params[:id])
      
      @site.update(:name => params[:name], 
                   :code => params[:code],
                   :latitude => params[:latitude],
                   :longitude => params[:longitude],
                   :state => params[:state])
      puts @site.valid?
      puts @site.errors.inspect()
      begin
       @site.save
      rescue
       puts @site = {:errors => @site.errors}
      end
    end
    respond_to do |format|
      format.json do
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @site.to_xml
      end
    end
  end
  
  # get_project_site
  # API for getting a site within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_site.json?id=1
  #
  # @params[String] id the id of the site within the project
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_project_site
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.get(params[:id])
    end
    respond_to do |format|
      format.json do
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @site.to_xml
      end
    end
  end

  # get_project_sites
  # API for getting all the sites within in a project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_sites.json?
  # 
  # @author Sean Cleveland
  #
  # @api public
  def get_project_sites
    @site = ""
    parent.managed_repository do
      @site = Voeis::Site.all()
    end
    respond_to do |format|
      format.json do
        render :json => @site.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @site.to_xml
      end
    end
  end
   
   # get_voeis_sites
   # API for getting all the sites that are public in the VOEIS system
   #
   #
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_voeis_sites.json?
   # 
   # @author Sean Cleveland
   #
   # @api public
   def get_voeis_sites
     @site = ""
     @site = Site.all()
     respond_to do |format|
       format.json do
         render :json => @site.to_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @site.to_xml
       end
     end
   end
   #************Variables
   
   # create_project_variable
   # API for creating a new variable within in a project
   # 
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_variable.json?variable_name=example&variable_code=example&speciation=unkown&sample_medium=surface water&state=MT 
   #
   # @param [String] variable_name the name of the variable - exists in variable_names_cv
   # @param [String] variable_code the unique code for identifying this variable
   # @param [String] speciation the speciation of the vairable - may be "unknown"
   #  
   # @author Sean Cleveland
   #
   # @api public
   def create_project_variable
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
   
   # get_project_variable
   # API for getting a variable within a Project
   #
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_variable.json?id=1
   #
   # @params[String] id the id of the site within the project
   #
   # @author Sean Cleveland
   #
   # @api public
   def get_project_variable
     @variable = ""
     parent.managed_repository do
       @variable = Voeis::Variable.get(params[:id])
     end
     respond_to do |format|
       format.json do
         render :json => @variable.to_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @variable.to_xml
       end
     end
   end
  # get_project_variables
  # API for getting all the sites within in a project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_variables.json?
  # 
  # @author Sean Cleveland
  #
  # @api public
  def get_project_variables
    @variable = ""
    parent.managed_repository do
      @variable = Voeis::Variable.all()
    end
    respond_to do |format|
      format.json do
        render :json => @variable.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @variable.to_xml
      end
    end
  end
  
   # get_voeis_variables
   # API for getting all the variables within in the VOEIS system
   #
   #
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_voeis_variables.json?
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_voeis_variables.xml?
   # @author Sean Cleveland
   #
   # @api public
   def get_voeis_variables
     @variables = ""
     @variables = Variable.all()
     respond_to do |format|
       format.json do
         render :json => @variables.to_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @variables.to_xml
       end
     end
   end
   
  # import_voeis_variable_to_project
  # API for getting a variable within in the VOEIS system into the current project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_voeis_variables.json?
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_voeis_variables.xml?
  # 
  # @params[Integer] voeis_variable_id, the id of the Voeis variable to import
  # 
  # @author Sean Cleveland
  #
  # @api public
  def import_voeis_variable_to_project    
    @var = Variable.get(params[:voeis_variable_id].to_i)
    @new_var
    parent.managed_repository do     
        begin      
          @new_var = Voeis::Variable.first_or_create(
                    :variable_code => @var.variable_code,
                    :variable_name => @var.variable_name,
                    :speciation =>  @var.speciation,
                    :variable_units_id => @var.variable_units_id,
                    :sample_medium =>  @var.sample_medium,
                    :value_type => @var.value_type,
                    :is_regular => @var.is_regular,
                    :time_support => @var.time_support,
                    :time_units_id => @var.time_units_id,
                    :data_type => @var.data_type,
                    :general_category => @var.general_category,
                    :no_data_value => @var.no_data_value)
        rescue
          @new_var = {"error" => @new_var.errors.inspect().to_s}
        end
    end#managed repo
    respond_to do |format|
      format.json do
        render :json => @new_var.to_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @new_var.to_xml
      end
    end
  end
  # **********SAMPLES*************** 
   
  # get_project_samples
  # API for getting all the samples within the current project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.json?
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.xml?
  # @author Sean Cleveland
  #
  # @api public
  def get_project_samples
   @samples = ""
   parent.managed_repository do
     @samples = Voeis::Sample.all()
   end
   respond_to do |format|
     format.json do
       render :json => @samples.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @samples.to_xml
     end
   end
  end

  # get_project_sample
  # API for getting a sample within the current project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/8524239c-e700-11df-8da7-6e9ffb75bc80/apivs/get_project_samples.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.xml?
  # 
  # @params[id] id the id of the sample within the project
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_project_sample
   @sample = ""
   parent.managed_repository do
     @sample = Voeis::Sample.get(params[:id].to_i)
   end
   
   respond_to do |format|
     format.json do
       render :json => @sample.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @sample.to_xml
     end
   end
  end
   
  # create_project_sample
  # API for creating a new sample within the current project
  #
  #
  # @example http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_sample.json?site_id=1&sample_type=Unknown&local_date_time=2010-11-12T12:25:31-07:00&material=insect&lab_sample_code=sampleco0004&lab_method_id=1&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.xml?
  # 
  # @params[Integer] id the id of the sample within the project
  # @params[String] sample_type, this is what type of sample this is example "grab"
  # @params[DateTime] local_date_time, this is the timestamp the sample was taken
  # @params[String] material, the type of the material the sample is examples (water, insect)
  # @params[String] lab_sample_code, this it the unique code used to identify the sample example "stream_sample_001"
  # @params[Integer] lab_method_id, this is the id of the method used to collect this sample
  # @params[Integer] site_id, this the id of the site that this sample was collected at
  #
  # @author Sean Cleveland
  #
  # @api public
  def create_project_sample
   @sample = ""
   parent.managed_repository do
     @site = Voeis::Site.get(params[:site_id].to_i)
     if @site.nil?
       @sample[:error] = "The Site ID:" + params[:site_id] +" is incorrect."
     else
       @sample = Voeis::Sample.new(:sample_type => params[:sample_type],
                                   :local_date_time => params[:local_date_time],
                                   :material => params[:material],
                                   :lab_sample_code => params[:lab_sample_code],
                                   :lab_method_id => params[:lab_method_id].to_i) 
       @sample.sites << @site
       begin
         @sample.save
       rescue
         @sample = {"error" => @sample.error.inspect().to_s}
       end
     end
   end
   respond_to do |format|
     format.json do
       render :json => @sample.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @sample.to_xml
     end
   end
  end
  
  # get_project_sample_measurements
  # API for getting all the samples within the current project
  #
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.json?
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/get_project_samples.xml?
  # 
  # @params[Integer] sample_id, the id of the sample to fetch measurements for
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_project_sample_measurements
   @measurements = ""
   parent.managed_repository do
     @measurements = Voeis::Sample.get(params[:sample_id].to_i).data_values
   end
   respond_to do |format|
     format.json do
       render :json => @measurements.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @measurements.to_xml
     end
   end
  end
  
  
  # create_project_sample_measurement
  # API for creating a new sample measurement within the current project
  #
  #
  # @example http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_sample_measurement.json?sample_id=5&variable_id=30&value=10.23423&replicate=3&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7
  # @example curl -d "sample_id=5&variable_id=30&value=10.23423&replicate=3&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7" http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_sample_measurement.json?
  # 
  # @params[Integer] sample_id the id of the sample within the project
  # @params[Integer] variable_id the id of variable to associate with this measurement
  # @params[String] value, this is what type of sample this is example "grab"
  # @params[String] replicate, specify if what replicate this was (OPTIONAL)
  #
  # @author Sean Cleveland
  #
  # @api public
  def create_project_sample_measurement
    @measurement = ""

     parent.managed_repository do
       @sample = Voeis::Sample.get(params[:sample_id].to_i)
       @variable = Voeis::Variable.get(params[:variable_id].to_i)
       if @sample.nil? 
         @measurement = {:error => "The Site ID:" + params[:site_id] +" is incorrect."}
       else
         if @variable.nil?
           @measurement = {:error => "The Variable ID:" + params[:variable_id] +" is incorrect."}
         else
           @measurement = Voeis::DataValue.new(                      
                          :data_value => /^[-]?[\d]+(\.?\d*)(e?|E?)(\-?|\+?)\d*$|^[-]?(\.\d+)(e?|E?)(\-?|\+?)\d*$/.match(params[:value].to_s) ? params[:value].to_f : -9999.0,
                          :local_date_time => @sample.local_date_time,
                          :utc_offset => @sample.local_date_time.to_time.utc_offset/(60*60),  
                          :date_time_utc => @sample.local_date_time.to_time.utc.to_datetime,            
                          :replicate => params[:replicate].empty? ? "None" : params[:replicate].to_s,
                          :string_value => params[:value].to_s)                                   
           @measurement.site << @sample.sites.first
           @measurement.sample << @sample
           @measurement.variable << @variable
           begin
             @measurement.save
           rescue
             @measurement = {"error" => @measurement.errors.inspect().to_s}
           end
           
           begin
             @sample.variables << @variable
             @sample.save
           rescue
             @measurement = @measurement.merge({"error" => @sample.errors.inspect().to_s})
           end
          end
       end
     end
     respond_to do |format|
       format.json do
         render :json => @measurement.to_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @measurement.to_xml
       end
     end
  end
   
   
   
   
   private
    # Parses a csv file using an existing data_column template
    # column values are stored in sensor_values
    #
    # @example parse_logger_csv_header("filename")
    #
    # @param [String] csv_file
    # @param [Object] data_stream_template
    # @param [Object] site
    #
    # @return
    #
    # @author Yogo Team
    #
    # @api private
    def parse_logger_csv(csv_file, data_stream_template, site)
      value_count = 0
      row_count = 0
      logger.info{"made BEFORE the opening of the CSV File"}
      csv_data = CSV.read(csv_file)
      logger.info{"made it past the opening of the CSV File"}
      path = File.dirname(csv_file)
      sensor_type_array = Array.new
      data_stream_col = Array.new
      data_stream_template.data_stream_columns.each do |col|
        sensor_type_array[col.column_number] = parent.managed_repository{Voeis::SensorType.first(:name => col.original_var + site.name)}
        data_stream_col[col.column_number] = col
      end
      if !data_stream_template.data_stream_columns.first(:name => "Timestamp").nil?
         data_timestamp_col = data_stream_template.data_stream_columns.first(:name => "Timestamp").column_number
      else
        data_timestamp_col = ""
        date_col = data_stream_template.data_stream_columns.first(:name => "Date").column_number
        time_col = data_stream_template.data_stream_columns.first(:name => "Time").column_number
      end
      parent.managed_repository do
        @sensor_value = ""
        csv_data[data_stream_template.start_line..-1].each do |row|
          (0..row.size-1).each do |i|
            if i != data_timestamp_col && i != date_col && i != time_col
              puts data_stream_col
              if data_stream_col[i].name != "ignore"
                #save to sensor_value and sensor_type
                if data_timestamp_col == ""
                  @sensor_value = Voeis::SensorValue.new(
                                                 :value => /^[-]?[\d]+(\.?\d*)(e?|E?)(\-?|\+?)\d*$|^[-]?(\.\d+)(e?|E?)(\-?|\+?)\d*$/.match(row[i]) ? row[i].to_f : -9999.0,
                                                 :units => data_stream_col[i].unit,
                                                 :timestamp => Time.parse(row[date_col].to_s + ' ' + row[time_col].to_s).to_datetime,
                                                 :published => false,
                                                  :string_value => row[i].to_s)
                else   
                  @sensor_value = Voeis::SensorValue.new(
                                                :value => /^[-]?[\d]+(\.?\d*)(e?|E?)(\-?|\+?)\d*$|^[-]?(\.\d+)(e?|E?)(\-?|\+?)\d*$/.match(row[i]) ? row[i].to_f : -9999.0,
                                                :units => data_stream_col[i].unit,
                                                :timestamp => row[data_timestamp_col.to_i],
                                                :published => false,
                                                :string_value => row[i].to_s)
                end
                logger.info {@sensor_value.valid?}
                logger.info{@sensor_value.errors.inspect()}
                @sensor_value.save
                logger.info{sensor_type_array[i].id}
                @sensor_value.sensor_type << sensor_type_array[i]
                @sensor_value.site << site
                @sensor_value.save
                value_count = value_count + 1
             end #end if
            end #end if
          end #end each_do[i]
          row_count = row_count + 1
        end #end each do [row]
        return_hash = Hash.new
        logger.info{"DONE PARSING"}
        logger.info{@sensor_value.as_json}
        return_hash = {:total_records_saved => value_count, :total_rows_parsed => row_count, :last_record => @sensor_value.as_json}
      end #end managed_repository
    end
    
     # Returns the specified row of a csv
     #
     # @example get_row("filename",4)
     #
     # @param [String] csv_file
     # @param [Integer] row
     #
     # @return [Array] an array whose elements are a csv-row columns
     #
     # @author Yogo Team
     #
     # @api private
     def get_row(csv_file, row)
       logger.info{"BEFORE CSV"}
       puts "BEFORE CSV"
       csv_data = CSV.read(csv_file)
       logger.info{"AFTER CSV"}
       path = File.dirname(csv_file)
       logger.info{"MORE AFTER CSV"}

       csv_data[row-1]
     end
     
     #'http://glassfish.msu.montana.edu/yogo/projects/Big%20Sky.json?api_key=Red-0bl_n0qxeOIwh4WQ&sitecode=UPGL-GLTNR24--MSU_UPGL-GLTNR24_MF_ESTBSWS&sensors[]=H2OCond_Avg&sensors[]=H2OTemp_Avg&sensors[]=AirTemp_Avg&sensors[]=AirTemp_SMP&hours=48&jsoncallback=?'
     def get_project_data_by_site_and_sensor
      
     end
end