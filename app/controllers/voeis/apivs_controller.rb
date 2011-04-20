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
  

  # def dojo_variables_for_tree
  #      @var_hash = Hash.new
  #      @var_hash = {:identifier=> 'id', :label=> 'name', :items=>Voeis::Variable.all().map{|v| {:id=>v.id, :name=>v.variable_code, :type=>"variable_code"}}}
  #      Voeis::GeneralCategoryCV.all.each do |cat|
  #        cat_hash=Hash.new
  #        cat_hash={:id=>cat.term, :name=>cat.term, :type=>"general_category"}
  #        vars = Voeis::Variable.all(:general_category=>cat.term,:fields=>[:variable_name],:unique=>true, :order=>[:variable_name.asc]).map{|v| v.variable_name}
  #             cat_hash[:children] = vars.map{|v| {"_reference"=>v+cat}}
  #             @var_name_array = Array.new
  #             vars.each do |v| 
  #               var_name_hash = Hash.new
  #               var_name_hash = {:id=>v+cat, :name=> v,:type=>"variable_name"}
  #               var_name_hash[:children] =  Voeis::Variable.all(:general_category=>cat, :variable_name=> v ).map{|var| {"_reference"=>var.id.to_s}}
  #               @var_name_array << var_name_hash
  #             end
  #        @var_hash[:items] << cat_hash
  #        @var_hash[:items] = @var_hash[:items] + @var_name_array
  #      end
  #      respond_to do |format|
  #        format.json do
  #         render :json => @var_hash.as_json, :callback => params[:jsoncallback]
  #        end
  #        format.xml do
  #         render :xml => @var_hash.to_xml
  #        end
  #      end
  #    end
  #  
  #*************DataStreams



  # pulls data from a data stream
  #
  # @example
  # http://localhost:4000/projects/fbf20340-af15-11df-80e4-002500d43ea0/apivs/get_data_stream_data.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7&data_stream_id=1&start_datetime=12/1/2010 12:23&end_datetime=12/1/2010 24:00:00
  #
  #
  # @param [Integer] :data_stream_id
  # @param [DateTime] :start_datetime pull data after this datetime
  # @param [DateTime] :end_datetime pull date before this datetime
  #
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_data_stream_data    
   @dts = ""
   @data_stream_values = Hash.new
   @values = Array.new
   parent.managed_repository do
     @dts= Voeis::DataStream.get(params[:data_stream_id].to_i)
     if @dts.nil?
       @data_stream_values[:error] = "There is no Data Stream with ID:"+params[:data_stream_id]
     else
       @dts.data_stream_columns.sensor_types.each do |sensor|
         @var_hash = Hash.new
         @var_hash = sensor.variables.first.as_json
         @var_hash = @var_hash.merge({'data' => sensor.sensor_values.all(:timestamp.gte => params[:start_datetime].to_time, :timestamp.lte => params[:end_datetime].to_time)})
         @values << @var_hash
       end
       @data_stream_values[:variables] = @values
     end
   end
   respond_to do |format|
     format.json do
       render :json => @data_stream_values.as_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @data_stream_values.to_xml
     end
   end
  end
  
  
   #  @data_stream_values = Hash.new
   #   parent.managed_repository do
   #     @data_stream = Voeis::DataStream.get(params[:data_stream_id].to_i)
   #     @data_stream.data_stream_columns.sensor_types.each do |sensor|
   #     #  @data_stream_values[sensor.variables.first.variable_name] = sensor.sensor_values.all(:timestamp.gte => params[:start_datetime].to_time, :timestamp.lte => params[:end_datetime].to_time)
   #       debugger
   #     #end
   #   end
   #   respond_to do |format|//home/rochellec/GPS
   #      format.json do
   #        render :json => @data_stream_values.to_json, :callback => params[:jsoncallback]
   #      end
   #   #   format.xml do
   #   #     render :xml => @data_stream_values.to_xml
   #   #   end
   #   end
   #   
   # end
  # 
  # curl -F datafile=@matt1item.csv -F data_template_id=19 -F start_line=1 -F  api_key=e79b135dcfeb6699bbaa6c9ba9c1d0fc474d7adb755fa215446c398cae057adf http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/upload_logger_data.json?
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
  # @param [Integer] :start_line the line which your data begins (if this is not specified the data-templates starting line will be used)
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
        @msg = "There was a problem parsing this file."
        name = Time.now.to_s + params[:datafile].original_filename 
        directory = "temp_data"
        @new_file = File.join(directory,name)
        File.open(@new_file, "wb"){ |f| f.write(params['datafile'].read)}
        begin 
            data_stream_template = Voeis::DataStream.get(params[:data_template_id].to_i)
            if params[:start_line].nil?
              start_line = data_stream_template.start_line
            else
              start_line = params[:start_line].to_i
            end
            lines =0
            File.open(@new_file, 'r') do |file|
              file.each_line do |line|
                lines +=1
              end
            end
            if lines < start_line
              @msg = @msg + " Your start_line: #{start_line} for file parsing is beyond the end of the file."
            end
            csv = CSV.open(@new_file, "r")
            (1..start_line).each do
              first_row = csv.readline
            end
            csv.close()
            path = File.dirname(@new_file)
          if first_row.count == data_stream_template.data_stream_columns.count
            flash_error = flash_error.merge(parent.managed_repository{Voeis::SensorValue.parse_logger_csv(@new_file, data_stream_template.id, data_stream_template.sites.first.id, start_line)})
          else
            #the file does not match the data_templates number of columns
            flash_error[:error] = "File does not match the data_templates number of columns. Columns in First Row:" + first_row.count.to_s +  " Voeis expected:" + data_stream_template.data_stream_columns.count.to_s + " rows."
            logger.info {"File does not match the data_templates number of columns."}
          end
        rescue   Exception => e
            logger.info {e.to_s}
            logger.info {"YEAH"}
          #problem parsing file
          flash_error[:error] = @msg
          logger.info {@msg}
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
  # @param [String] id the id of the site within the project
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
  
  
  
   # http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_data_stream.json?
   # "name=mytest&start_line=1&site_id=1&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7"
   
   
  # create_project_data_stream
  # API for creating a new data stream within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_data_stream.json?
  #
  # @param [String] name the name of the data stream 
  # @param [Integer] start_line then line in the file the data begins on
  # @param [Integer] site_id the id of the project site to associate with this data_stream
  #
  # @author Sean Cleveland
  #
  # @return [JSON String] an array of data_templates that exist for the project and each ones properties and values
  # 
  # @api public
  def create_project_data_stream
    @stream = ""
    parent.managed_repository do
      @stream = Voeis::DataStream.first_or_create(
        :name => params[:name], 
        :start_line => params[:start_line], 
        :filename => "NA")
      @stream.sites << Voeis::Site.get(params[:site_id])
      @stream.save
    end
    respond_to do |format|
     format.json do
       render :json => @stream.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @stream.to_xml
     end
    end
  end
  
  
  # http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_data_stream_column.json?
   # "name=mytestcol&column_number=1&type="Legacy"&unit="None"&original_var="Whatever"&variable_id=20&data_stream_id=8&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7"
  
  
  # create_project_data_stream_column
  # API for creating a new data_stream_column within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_data_stream_column.json?
  #
  # @param [String] name the name of the data stream column - header name usually
  # @param [Integer] column_number the column number to parse with this data_stream_column object
  # @param [String] type the type of data_stream_column i.e. ("Legacy, Sensor") - optional
  # @param [String] unit the name of the unit - optional
  # @param [String] original_var the name of original headers variable name - optional
  # @param [Integer] variable_id the id of the project variable to associate with this data_stream_column
  # @param[Integer] data_stream_id the id of the data_stream to associate this data_stream_column with
  #
  # @author Sean Cleveland
  #
  # @return [JSON String] an array of data_templates that exist for the project and each ones properties and values
  # 
  # @api public
  def create_project_data_stream_column
     @data_column = ""
      parent.managed_repository do
        @data_column = Voeis::DataStreamColumn.create(
          :column_number => params[:column_number],
          :name => params[:name],
          :type => params[:type],
          :unit => params[:unit],
          :original_var => params[:original_var])
        @data_column.data_streams << Voeis::DataStream.get(params[:data_stream_id])
        @data_column.variables << Voeis::Variable.get(params[:variable_id])
        @data_column.save!
      end
      respond_to do |format|
       format.json do
         render :json => @data_column.to_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @data_column.to_xml
       end
      end
  end
  
  
  # http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_sensor_type.json?
   # "name=mytest_sensor&min=0&max=0&differece=0&data_stream_column_id=92&variable_id=20&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7"
  
  
  # create_project_sensor_type
  # API for creating a sensor_type within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_sensor_type.json?
  #
  # @param [String] name the name of the data stream 
  # @param [Integer] min the minimum sensor should read if working correctly
  # @param [Integer] max the maximum a sensor should read if working correctly
  # @param [Integer] difference the most one reading should differ from the last
  # @param [Integer] data_stream_column_id the data_stream_column to associate with this sensor_type
  # @param [Integer] variable_id the id of the project variable to associate with this data_stream_column
  #
  # @author Sean Cleveland
  #
  # @return [JSON String] an array of data_templates that exist for the project and each ones properties and values
  # 
  # @api public
  def create_project_sensor_type
    @sensor_type = ""
    parent.managed_repository do
      @sensor_type = Voeis::SensorType.create(
                    :name => params[:name],
                    :min => params[:min],
                    :max => params[:max],
                    :difference => params[:difference])
      #Add sites and variable associations to senor_type
      data_column = Voeis::DataStreamColumn.get(params[:data_stream_column_id])
      project_site = data_column.data_streams.first.sites.first
      project_var = Voeis::Variable.get(params[:variable_id])
      @sensor_type.sites << project_site
      @sensor_type.variables <<  project_var
      @sensor_type.data_stream_columns << data_column
      @sensor_type.save!
      project_site.variables << project_var
      project_site.save!
    end
    respond_to do |format|
     format.json do
       render :json => @sensor_type.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @sensor_type.to_xml
     end
    end
  end
  
  #************Sensor Values
  
  # http://localhost:3000/projects/b6db01d0-e606-11df-863f-6e9ffb75bc80/apivs/create_project_sensor_value.json?
   # "value=23.2&unit=Whatever&timestamp=Sat Nov 20 13:54:18 -0700 2010&published=false&sensor_type_id=61&api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7"
  
  # create_project_sensor_value
  # API for creating a sensor_value within a Project
  #
  # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_sensor_value.json?
  #
  # @param [Float] value the value of the sensor measurement
  # @param [String] unit the name of the units
  # @param [Timestamp] timestamp the timestamp the sensor measurement was taken at
  # @param [Float] vertical_offset - the offset from the sites offset (by default is 0.0)
  # @param [Boolean] published - true if this sensor measurement has been published to the HIS server
  # @param [Integer] sensor_type_id the sensor_type to associate this sensor_value with
  #
  # @author Sean Cleveland
  #
  # @return [JSON String] an array of data_templates that exist for the project and each ones properties and values
  # 
  # @api public
  def create_project_sensor_value
    @sensor_type = ""
    @sensor_value = 
    parent.managed_repository do
      @sensor_type = Voeis::SensorType.get(params[:sensor_type_id])
      @sensor_value = Voeis::SensorValue.create(
        :value => params[:value].to_f,
        :units => params[:unit],
        :timestamp => params[:timestamp],
        :vertical_offset => params[:vertical_offset].to_f,
        :published => params[:published],
        :string_value => params[:value])
      @sensor_value.sensor_type << @sensor_type
      @sensor_value.site << @sensor_type.sites.first
      @sensor_value.variables << @sensor_type.variables.first
      @sensor_value.save!
    end
    respond_to do |format|
     format.json do
       render :json => @sensor_value.to_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @sensor_value.to_xml
     end
    end
  end
  
  
  #************Sites
  
  # pulls data from a within a project's site
  #
  # @example
  # http://localhost:4000/projects/fbf20340-af15-11df-80e4-002500d43ea0/apivs/get_project_site_data.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7&site_id=1&start_datetime=12/1/2010 12:23&end_datetime=12/1/2010 24:00:00
  #
  #
  # @param [Integer] :site_id the id of the site to pull data for
  # @param [DateTime] :start_datetime pull data after this datetime
  # @param [DateTime] :end_datetime pull date before this datetime
  #
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_project_site_data    
   @site = ""
   @data_values = Hash.new
   @values = Array.new
   parent.managed_repository do
     @site= Voeis::Site.get(params[:site_id].to_i)
     if @site.nil?
        @data_values[:error] = "There is no Site with ID:"+ params[:site_id]
     else
       @site.variables. each do |var|
         @var_hash = Hash.new
         @var_hash = var.as_json
         if !var.sensor_types.first.nil?
           @var_hash = @var_hash.merge({'time_series_data' => @site.sensor_types.sensor_values.all(:timestamp.gte => params[:start_datetime].to_time, :timestamp.lte => params[:end_datetime].to_time) & var.sensor_types.sensor_values.all(:timestamp.gte => params[:start_datetime].to_time, :timestamp.lte => params[:end_datetime].to_time)})
         end
         @var_hash = @var_hash.merge({'sample_data' => var.data_values.all(:local_date_time.gte => params[:start_datetime].to_time, :local_date_time.lte => params[:end_datetime].to_time)})
         @values << @var_hash
       end
       @data_values[:variables] = @values
       @data_values[:site] = @site.as_json
     end
   end
   respond_to do |format|
     format.json do
       render :json => @data_values.as_json, :callback => params[:jsoncallback]
     end
     format.xml do
       render :xml => @data_values.to_xml
     end
   end
  end
  
  # pulls data from a within a project's site
  #
  # @example
  # http://localhost:4000/projects/fbf20340-af15-11df-80e4-002500d43ea0/apivs/get_project_site_sensor_data_last_update.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7&site_id=1&start_datetime=12/1/2010 12:23&end_datetime=12/1/2010 24:00:00
  #
  #
  # @param [Integer] :site_id the id of the site to pull data for
  #
  #
  # @author Sean Cleveland
  #
  # @api public
  def get_project_site_sensor_data_last_update    
   @site = ""
   @data_values = Hash.new
   @values = Array.new
   parent.managed_repository do
     @site= Voeis::Site.get(params[:site_id].to_i)
     if @site.nil?
        @data_values[:error] = "There is no Site with ID:"+ params[:site_id]
     else
       @site.sensor_types.each do |sensor|
         var = sensor.variables.first
         @var_hash = Hash.new
         @var_hash = var.as_json
         @var_hash = @var_hash.merge({'data' =>       sensor.sensor_values.last(:order => [:timestamp.asc]).as_json}) 
         @values << @var_hash
       end
       @data_values[:variables] = @values
       @data_values[:site] = @site.as_json
     end
     respond_to do |format|
       format.json do
         render :json => @data_values.as_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @data_values.to_xml
       end
     end
    end
  end
  
  
  
  
  
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
  # @param [String] id the id of the site within the project
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
     @site = Voeis::Site.all()
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
   
   # pulls data from a within a project's by the variable
   #
   # @example
   # http://localhost:4000/projects/fbf20340-af15-11df-80e4-002500d43ea0/apivs/get_project_variable_data.json?api_key=d7ef0f4fe901e5dfd136c23a4ddb33303da104ee1903929cf3c1d9bd271ed1a7&variable_id=1&start_datetime=12/1/2010 12:23&end_datetime=12/1/2010 24:00:00
   #
   #
   # @param [Integer] :variable_id the id of the variable to pull data for
   # @param [DateTime] :start_datetime pull data after this datetime
   # @param [DateTime] :end_datetime pull date before this datetime
   #
   #
   # @author Sean Cleveland
   #
   # @api public
   def get_project_variable_data    
    @var = ""
    @data_values = Hash.new
    @values = Array.new
    parent.managed_repository do
      @var= Voeis::Variable.get(params[:variable_id].to_i)
      if @var.nil?
        @data_values[:error] = "There is no variable with the ID:"+params[:variable_id]
      else
        @var_hash = Hash.new
        @var_hash = @var.as_json
        if !@var.sensor_types.first.nil?
          @var_hash = @var_hash.merge({'time_series_data' =>  @var.sensor_types.sensor_values.all(:timestamp.gte => params[:start_datetime].to_time, :timestamp.lte => params[:end_datetime].to_time)})
          @var_hash = @var_hash.merge({'sample_data' => @var.data_values.all(:local_date_time.gte => params[:start_datetime].to_time, :local_date_time.lte => params[:end_datetime].to_time)})
          @values << @var_hash
        end
        @data_values[:variable] = @values
        @data_values[:project] = parent.as_json
      end
    end
    respond_to do |format|
      format.json do
        render :json => @data_values.as_json, :callback => params[:jsoncallback]
      end
      format.xml do
        render :xml => @data_values.to_xml
      end
    end
   end 
   
   
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
   # @param [String] id the id of the site within the project
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
     @variables = Voeis::Variable.all()
     respond_to do |format|
       format.json do
         render :json => @variables.as_json, :callback => params[:jsoncallback]
       end
       format.xml do
         render :xml => @variables.to_xml
       end
     end
   end
   
   
   # update_project_variable
   # API for creating a new variable within in a project
   # 
   # @example http://voeis.msu.montana.edu/projects/e787bee8-e3ab-11df-b985-002500d43ea0/apivs/create_project_variable.json?variable_name=example&variable_code=example&speciation=unkown&sample_medium=surface water&state=MT 
   #
   # @param [Integer] id the ID of the project variable - this is required
   # @param [String] variable_name the name of the variable - exists in variable_names_cv
   # @param [String] variable_code the unique code for identifying this variable
   # @param [String] speciation the speciation of the vairable - may be "unknown"
   #  
   # @author Sean Cleveland
   #
   # @api public
   def update_project_variable
     @variable = ""
     if !params[:id].nil?
       parent.managed_repository do
         @variable = Voeis::Variable.get(params[:id])
         Voeis::Variable.properties.each do |prop|
           if prop.name.to_s != "id"
             if !params[prop.name].nil?
               @variable[prop.name.to_s] = params[prop.name.to_s]
             end
           end
         end
         @variable.save
       end
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
   
   def update_voeis_variable
     @variable = ""
     if !params[:id].nil?
       @variable = Voeis::Variable.get(params[:id])
       Voeis::Variable.properties.each do |prop|
         if prop.name.to_s != "id"
           if !params[prop.name].nil?
             @variable[prop.name.to_s] = params[prop.name.to_s]
           end
         end
       end
       @variable.save
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
   
   
   def get_dojo_voeis_variables
     @variables = Hash.new
     @variables = {:identifer=>"id", :label=> "variable_code", :items => Variable.all()}
     respond_to do |format|
       format.json do
         render :json => @variables.as_json, :callback => params[:jsoncallback]
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
  # @param [Integer] voeis_variable_id, the id of the Voeis variable to import
  # 
  # @author Sean Cleveland
  #
  # @api public
  def import_voeis_variable_to_project    
    @var = Voeis::Variable.get(params[:voeis_variable_id].to_i)
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
 
 
 
  def dojo_variables_for_tree
    @var_hash = Hash.new
    @var_hash = {:identifier=> 'id', :label=> 'name', :items=>Voeis::Variable.all().map{|v| {:id=>v.id, :name=>v.variable_code, :type=>"variable_code"}}}
    Voeis::GeneralCategoryCV.each do |cat|
      cat_hash=Hash.new
      cat_hash={:id=>cat.term, :name=>cat.term, :type=>"general_category"}
      vars = Voeis::Variable.all(:general_category=>cat.term,:fields=>[:variable_name],:unique=>true, :order=>[:variable_name.asc]).map{|v| v.variable_name}
           cat_hash[:children] = vars.map{|v| {"_reference"=>v+cat.term}}
           @var_name_array = Array.new
           vars.each do |v| 
             var_name_hash = Hash.new
             var_name_hash = {:id=>v+cat.term, :name=> v,:type=>"variable_name"}
             var_name_hash[:children] =  Voeis::Variable.all(:general_category=>cat.term, :variable_name=> v ).map{|var| {"_reference"=>var.id.to_s}}
             @var_name_array << var_name_hash
           end
      @var_hash[:items] << cat_hash
      @var_hash[:items] = @var_hash[:items] + @var_name_array
    end
    respond_to do |format|
      format.json do
       render :json => @var_hash.as_json, :callback => params[:jsoncallback]
      end
      format.xml do
       render :xml => @var_hash.to_xml
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
  # @param [Integer] id the id of the sample within the project
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
  # @param [Integer] id the id of the sample within the project
  # @param [String] sample_type, this is what type of sample this is example "grab"
  # @param [DateTime] local_date_time, this is the timestamp the sample was taken
  # @param [String] material, the type of the material the sample is examples (water, insect)
  # @param [String] lab_sample_code, this it the unique code used to identify the sample example "stream_sample_001"
  # @param [Integer] lab_method_id, this is the id of the method used to collect this sample
  # @param [Integer] site_id, this the id of the site that this sample was collected at
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
  # @param [Integer] sample_id, the id of the sample to fetch measurements for
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
  # @param [Integer] sample_id the id of the sample within the project
  # @param [Integer] variable_id the id of variable to associate with this measurement
  # @param [String] value, this is what type of sample this is example "grab"
  # @param [String] replicate, specify if what replicate this was (OPTIONAL)
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
 
     
     #'http://glassfish.msu.montana.edu/yogo/projects/Big%20Sky.json?api_key=Red-0bl_n0qxeOIwh4WQ&sitecode=UPGL-GLTNR24--MSU_UPGL-GLTNR24_MF_ESTBSWS&sensors[]=H2OCond_Avg&sensors[]=H2OTemp_Avg&sensors[]=AirTemp_Avg&sensors[]=AirTemp_SMP&hours=48&jsoncallback=?'
     def get_project_data_by_site_and_sensor
      
     end
end