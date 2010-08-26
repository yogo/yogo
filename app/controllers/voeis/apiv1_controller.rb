class Voeis::Apiv1Controller < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'apiv1s',
            :route_instance_name => 'apiv1',
            :collection_name => 'apiv1s',
            :instance_name => 'apiv1',
            :resource_class => Voeis::DataStream


  # GET /variables/new
  def new
    puts "before*************************************************"
    if !params[:data_stream_ids].empty?
      puts "here1"
      params[:data_stream_ids].each do |data_stream_id|
        data_stream = parent.managed_repository{Voeis::DataStream.get(data_stream_id)}
        site = data_stream.sites.first
        @download_meta_array = Array.new
        @sensor_hash = Hash.new
        data_stream.data_stream_columns.all(:order => [:column_number.asc]).each do |data_col|
          puts data_col.name
          @value_array= Array.new
          sensor = data_col.sensor_types.first
          
          if !sensor.nil?
            if !sensor.variables.empty?
            if !params[:variable_ids].nil?
              var = sensor.variables.first
            params[:variable_ids].each do |var_id|
              puts var_id
              puts var.id
              puts params[:hours]
              puts "boom"
              puts sensor.name
              puts var.variable_name
              if var.id == var_id.to_i     
                puts sensor.variables.first.variable_name + "slam"
                puts "uhuh"
                if !params[:start_date].nil? && !params[:end_date].nil?     
                  puts "UH"
                  sensor.sensor_values(:timestamp.gte => params[:start_date],:timestamp.lte => params[:end_date], :order => (:timestamp.asc)).each do |val|
                    @value_array << [val.timestamp, val.value]
                  end #end do val
                elsif !params[:hours].nil?
                  puts "Yeah"
                  last_date = sensor.sensor_values.last(:order => [:timestamp.asc]).timestamp
                  puts "boo"
                  start_date = (last_date.to_time - params[:hours].to_i.hours).to_datetime
                  puts "big"
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
      render :json => @download_meta_array.to_json, :callback => params[:jsoncallback]
    end
  end
  end
end