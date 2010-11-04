class ProjectsController < InheritedResources::Base
  respond_to :html, :json

   #export the results of search/browse to a csv file
  def export
    headers = JSON[params[:column_array]]
    rows = JSON[params[:row_array]]
    column_names = Array.new
    headers.each do |col|
      column_names << col
    end
    csv_string = FasterCSV.generate do |csv|
      csv << column_names
      rows.each do |row|
        csv << row
      end
    end

    filename = params[:site_name] + ".csv"
    send_data(csv_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => filename)
  end

  def show
    # This should be a [
    #                   [ timestamp, site.sensor.variable.value, site.sensor.variable.value ]
    #                   [ timestamp, site.sensor.variable.value, site.sensor.variable.value ]
    #                   [ ... ]
    #                  ]
    @current_data = Array.new
    @items = Array.new
    @start_time = nil
    @end_time = nil
    @label_array = ["Timestamp"]
    if params.has_key?(:range)
      @start_time = Date.civil(params[:range][:"start_date(1i)"].to_i,params[:range]      [:"start_date(2i)"].to_i,params[:range][:"start_date(3i)"].to_i)
      @end_time = Date.civil(params[:range][:"end_date(1i)"].to_i,params[:range]    [:"end_date(2i)"].to_i,params[:range][:"end_date(3i)"].to_i)
      @start_time = @start_time.to_datetime
      @end_time = @end_time.to_datetime + 23.hour + 59.minute


      # if params.has_key?(:variables_start)
      #   @start_time = params[:variables_start].to_datetime
      # else
      #   @start_time = DateTime.now - 7
      # end
      #
      # if params.has_key?(:variables_end)
      #   @end_time = params[:variables_end].to_datetime
      # else
      #   @end_time = DateTime.now
      # end
      var_label=""

      if params.has_key?(:variables)
        params[:variables].keys.each do |site_id|
          site = resource.managed_repository { Voeis::Site.get(site_id) }
          if params[:variables][site_id].empty?
            site.variables.each do |variable|
              var_label = ""
              var_label =  site.name if params[:site_display]
              var_label = var_label +  variable.variable_name
              var_label = var_label + variable.sample_medium if params[:sample_medium_display]
              var_label = var_label + variable.data_type if params[:data_type_display]
              var_label = var_label + Unit.get(variable.variable_units_id).units_name if params[:units_display]
              
              @label_array << var_label #"#{site.name} #{variable.variable_name}"
              @items << [site, variable]
            end
          else
            params[:variables][site_id].each do |variable_id|
              variable = resource.managed_repository{ Voeis::Variable.get(variable_id) }
              var_label = ""
              var_label =  site.name + "|" if params[:site_display]
              var_label = var_label +  variable.variable_name
              var_label = var_label + "|" + variable.sample_medium if params[:sample_medium_display]
              var_label = var_label + "|" + variable.data_type if params[:data_type_display]
              var_label = var_label + "|" + Unit.get(variable.variable_units_id).units_name if params[:units_display]
              @label_array << var_label #{}"#{site.name} #{variable.variable_name}"
              @items << [site, variable]
            end
          end
        end
      end

      # Fill in the current data
      data_lists = Hash.new
      timestamps = Set.new
      @items.each do |site, variable|
        if site.sensor_types.count > 0
          sensor = site.sensor_types.select{|s| s.variables.include?(variable)}[0]
          if !sensor.nil?
            values = sensor.sensor_values(:timestamp.gte => @start_time, :timestamp.lte => @end_time)
            data_lists[site] ||= Hash.new
            data_lists[site][variable] ||= Hash.new
            values.each do |v|
              data_lists[site][variable][v.timestamp] = v.value
            end
            timestamps.merge(values.map {|v| v.timestamp})
          end
        end
        if site.samples.count > 0
          sample = site.samples.select{|s| s.variables.include?(variable)}[0]
          if !sample.nil?
            values = sample.data_values.all(:local_date_time.gte => @start_time, :local_date_time.lte => @end_time).intersection(variable.data_values)
            data_lists[site] ||= Hash.new
            data_lists[site][variable] ||= Hash.new
            values.each do |v|
     
                data_lists[site][variable][v.local_date_time] = v.data_value

            end
            timestamps.merge(values.map {|v| v.local_date_time})
          end
        end
      end

      timestamps.to_a.sort.each do |ts|
        tmp_array = Array.new
        tmp_array << ts
        @items.each do |site, variable|
          if data_lists[site][variable].has_key?(ts)
            value = data_lists[site][variable][ts]
          else
            value = nil
          end
          tmp_array << value
        end
        @current_data << tmp_array
      end
    end
    super
  end

  def destroy
    flash[:notice] = "Project deleting is disabled."
    redirect_to(:back)
  end

  protected
  def resource
    @project ||= resource_class.get(params[:id])
  end

  def collection
    @projects ||= resource_class.paginate(:page => params[:page])
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