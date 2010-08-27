class ProjectsController < InheritedResources::Base
  respond_to :html, :json
  
  protected
  def resource
    @project ||= resource_class.get(params[:id])
  end

  def collection
    @projects ||= resource_class.all
  end

  def resource_class
    @initial_query ||= begin
      q = Project.all(:is_private => false)
      q =  (q | current_user.projects ) unless current_user.nil?
      q.access_as(current_user)
    end
  end
  
  def get_json_data(data_stream_ids, variable_ids, start_date = nil, end_date= nil, hour = nil)
     if !data_stream_ids.empty?
       @download_meta_array = Array.new
       data_stream_ids.each do |data_stream_id|
         data_stream = parent.managed_repository{Voeis::DataStream.get(data_stream_id)}
         site = data_stream.sites.first
         @sensor_hash = Hash.new
         data_stream.data_stream_columns.all(:order => [:column_number.asc]).each do |data_col|
           @value_array= Array.new
           sensor = data_col.sensor_types.first

           if !sensor.nil?
             if !sensor.variables.empty?
             if !variable_ids.nil?
               var = sensor.variables.first
             variable_ids.each do |var_id|
               if var.id == var_id.to_i     
                 if !start_date.nil? && !end_date.nil?     
                   sensor.sensor_values(:timestamp.gte => start_date,:timestamp.lte => end_date, :order => (:timestamp.asc)).each do |val|
                     @value_array << [val.timestamp, val.value]
                   end #end do val
                 elsif !hours.nil?
                   last_date = sensor.sensor_values.last(:order => [:timestamp.asc]).timestamp
                   start_date1 = (last_date.to_time - params[:hours].to_i.hours).to_datetime
                   sensor.sensor_values(:timestamp.gte => start_date1, :order => (:timestamp.asc)).each do |val|
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
    @download_meta_array.to_json
   # respond_to do |format|
   #   format.json do
   #     format.html
   #     render :json => @download_meta_array, :callback => params[:jsoncallback]
   #   end
   # end
   end
end