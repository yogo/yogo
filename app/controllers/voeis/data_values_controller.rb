class Voeis::DataValuesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'data_values',
            :route_instance_name => 'data_value',
            :collection_name => 'data_values',
            :instance_name => 'data_value',
            :resource_class => Voeis::DataValue
  
  
  def pre_process
    @project = parent
    @general_categories = GeneralCategoryCV.all
  end
  
  def pre_upload
     require 'csv_helper'
     
     @project = parent
     #@project = Project.first(:id => params[:project_id])
      @variables = Variable.all
      @sites = parent.managed_repository{ Voeis::Site.all }
      @samples = parent.managed_repository{ Voeis::Sample.all }
      if !params[:datafile].nil? && datafile = params[:datafile]
        if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
              'application/octet-stream','application/csv'].include?(datafile.content_type)
          flash[:error] = "File type #{datafile.content_type} not allowed"
          redirect_to(:controller =>"voeis/data_values", :action => "pre_process", :params => {:id => params[:project_id]})

        else
          name = params['datafile'].original_filename
          directory = "temp_data"
          @new_file = File.join(directory,name)
          File.open(@new_file, "wb"){ |f| f.write(params['datafile'].read)}
          
          @start_line = params[:start_line].to_i
          @start_row = get_row(datafile.path, params[:start_line].to_i)
          @row_size = @start_row.size-1
          
          header_row = Array.new
          
          @var_array = Array.new
          @var_array[0] = ["","","","","","",""]
          @opts_array = Array.new
          @variables.all(:general_category => params[:general_category], :order => [:variable_name.asc]).each do |var|
            @opts_array << [var.variable_name+":"+var.sample_medium+':'+ var.data_type+':'+Unit.get(var.variable_units_id).units_name, var.id.to_s]
          end
          if params[:start_line].to_i != 1
            header_row = get_row(datafile.path, params[:start_line].to_i - 1)
          
            (0..@row_size).each do |i|
               @var_array[i] = [header_row[i],"","",opts_for_select(@opts_array),"","",""]
              end
          else
            (0..@row_size).each do |i|
              @var_array[i] = ["","","",opts_for_select(@opts_array),"","",""]
             end
          end
          
          #parse csv file into array
          @csv_array = Array.new
          csv_data = CSV.read(@new_file)
          i = @start_line
          csv_data[@start_line-1..-1].each do |row|
            @csv_array[i] = row.map! { |k| "#{k}" }.join(",")
            i = i + 1
          end
          @csv_size = i -1

      end
     end
  end
  
  def opts_for_select(opt_array, selected = nil)
     option_string =""
     if !opt_array.empty?
       opt_array.each do |opt|
         if opt[1] == selected
           option_string = option_string + '<option selected="selected" value='+opt[1]+'>'+opt[0]+'</option>'
         else
           option_string = option_string + '<option value='+opt[1]+'>'+opt[0]+'</option>'
         end
       end
     end
     option_string
  end
  
  # Parses a csv file containing sample data values
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
   # @api public
   def parse_sample_data_csv(csv_file, data_stream_template, site)
     csv_data = CSV.read(csv_file)
     path = File.dirname(csv_file)
     sensor_type_array = Array.new
     data_stream_col = Array.new
     data_stream_template.data_stream_columns.each do |col|
       sensor_type_array[col.column_number] = parent.managed_repository{Voeis::SensorType.first(:name => col.original_var + site.name)}
       data_stream_col[col.column_number] = col
     end
     data_timestamp_col = data_stream_template.data_stream_columns.first(:name => "Timestamp").column_number
     csv_data[data_stream_template.start_line..-1].each do |row|
       (0..row.size-1).each do |i|
         if i != data_timestamp_col
           puts data_stream_col
           if data_stream_col[i].name != "ignore"
             #save to sensor_value and sensor_type
             parent.managed_repository{
             sensor_value = Voeis::SensorValue.new(
                                           :value => row[i],
                                           :units => data_stream_col[i].unit,
                                           :timestamp => row[data_timestamp_col],
                                           :published => false)
             sensor_value.save
             sensor_value.sensor_type << sensor_type_array[i]
             sensor_value.site << site
             sensor_value.save}
          end
         end
       end
     end
   end

   def store_sample_data

     range = params[:row_size].to_i
     #store all the Variables in the managed repository
     @col_vars = Array.new
     (0..range).each do |i|
        @var = Variable.get(params["column"+i.to_s])
        parent.managed_repository do
          if !params["ignore"+i.to_s]            
            variable = Voeis::Variable.first_or_create(
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
            @col_vars[i] = variable
          end #end if
        end#managed repo
     end  #end i loop
 
      puts "DONE WITH VARS"
     #create csv_row array
     @csv_row = Array.new
     csv_data = CSV.read(params[:datafile])
     i = params[:start_line].to_i-1
     puts "BEFORE"
     csv_data[params[:start_line].to_i-1..-1].each do |row|
       @csv_row[i] = row
       i = i + 1
     end#end row loop
     puts "DONE WITH CSV"
     (params[:start_line].to_i-1..params[:csv_size].to_i).each do |row|
       if !@csv_row[row].nil?
       parent.managed_repository do
         puts "CSVSample: #{params["csv_sample"+(row +1).to_s]}"
         @sample = Voeis::Sample.get(params["csv_sample"+(row+1).to_s])
         (0..range).each do |i|
           puts "outside the if"
           if params[:replicate].to_i != i && params[:timestamp_col].to_i != i && @csv_row[row][i] != ""&& !params["ignore"+i.to_s]
             #store data value for this column(i) and row
             puts "We should be saving right"
             #sort out replicate
             if params[:replicate] == "None"
               rep = "0"
             else
               rep = @csv_row[row][params[:replicate].to_i]
             end
             puts "REPLICATE = #{rep}"
             #need to store either the timestamp col or the applied timestamp
             if params[:timestamp_col] == "None"
               #store the applied timestamp
               puts "The TIME: #{params[:time]["stamp(1i)"]}-#{params[:time]["stamp(2i)"]}-#{params[:time]["stamp(3i)"]}T#{params[:time]["stamp(4i)"]}:#{params[:time]["stamp(5i)"]}:00#{ActiveSupport::TimeZone[params[:time][:zone]].utc_offset/(60*60)}:00"
               puts d_time = DateTime.parse("#{params[:time]["stamp(1i)"]}-#{params[:time]["stamp(2i)"]}-#{params[:time]["stamp(3i)"]}T#{params[:time]["stamp(4i)"]}:#{params[:time]["stamp(5i)"]}:00#{ActiveSupport::TimeZone[params[:time][:zone]].utc_offset/(60*60)}:00")
               new_data_val = Voeis::DataValue.new(:data_value => @csv_row[row][i].to_f, 
                  :local_date_time => d_time,
                  :utc_offset => ActiveSupport::TimeZone[params[:time][:zone]].utc_offset/(60*60),  
                  :date_time_utc => d_time.to_time.utc.to_datetime,  
                  :replicate => rep) 
               puts "Value is valid: #{new_data_val.valid?}"
               new_data_val.save
               puts new_data_val.errors.inspect() 
             else
               #store the column timestamp
               time = csv_row[row][params[:timestamp_col]]
               #TODO - make sure time stores correctly
               new_data_val = Voeis::DataValue.create(:data_value => @csv_row[row][i].to_f, 
                   :local_date_time => DateTime.new(time),
                   :utc_offset => ActiveSupport::TimeZone[params[:time][:zone]].utc_offset/(60*60),  
                   :date_time_utc => DateTime.new(time),  
                   :replicate => rep)
             end #end if
             new_data_val.variable << @col_vars[i]
             new_data_val.save
             puts @sample
             new_data_val.sample << @sample
             new_data_val.save
             @sample.sites.each do |site|
               site.variables << @col_vars[i]
               site.save
             end
            end #end if
           end #end i loop
          end #end if @csv_array.nil?
       end #end managed repo
     end #end row loop
     #parent.publish_his
     flash[:notice] = "File parsed and stored successfully."
     redirect_to project_path(params[:project_id])
   end# end def
end
