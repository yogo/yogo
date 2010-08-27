class ProjectsController < InheritedResources::Base
  respond_to :html, :json

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

    # Creates the labels for data
    @label_array = ["timestamp"]

    if params.has_key?(:variables_start)
      @start_time = params[:variables_start].to_datetime
    else
      @start_time = DateTime.now - 7
    end

    if params.has_key?(:variables_end)
      @end_time = params[:variables_end].to_datetime
    else
      @end_time = DateTime.now
    end

    if params.has_key?(:variables)
      params[:variables].keys.each do |site_id|
        site = resource.managed_repository { Voeis::Site.get(site_id) }
        if params[:variables][site_id].empty?
          site.variables.each do |variable|
            @label_array << "#{site.name} #{variable.variable_name}"
            @items << [site, variable]
          end
        else
          params[:variables][site_id].each do |variable_id|
            variable = resource.managed_repository{ Voeis::Variable.get(variable_id) }
            @label_array << "#{site.name} #{variable.variable_name}"
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
        values = sensor.sensor_values(:timestamp.gte => @start_time, :timestamp.lte => @end_time)
        data_lists[site] ||= Hash.new
        data_lists[site][variable] ||= Hash.new
        values.each do |v|
          data_lists[site][variable][v.timestamp] = v.value
        end
        timestamps.merge(values.map {|v| v.timestamp})
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
    super
  end

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
end