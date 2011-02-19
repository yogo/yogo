class Voeis::SensorValuesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'sensor_values',
            :route_instance_name => 'sensor_value',
            :collection_name => 'sensor_values',
            :instance_name => 'sensor_value',
            :resource_class => Voeis::SensorValue
  
  def new_field_measurement
      @sites = parent.managed_repository{Voeis::Site.all}
      @variables = Variable.all
      @units = Unit.all
  end
  
  def create_field_measurement
    @var = Variable.get(params[:variable].to_i)
    units = Unit.all
    @unit = units.first(:id => @var.variable_units_id)
    parent.managed_repository do
      d_time = DateTime.parse("#{params[:time]["stamp(1i)"]}-#{params[:time]["stamp(2i)"]}-#{params[:time]["stamp(3i)"]}T#{params[:time]["stamp(4i)"]}:#{params[:time]["stamp(5i)"]}:00#{ActiveSupport::TimeZone[params[:time][:zone]].utc_offset/(60*60)}:00")
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

      unit = Voeis::Unit.first_or_create(:units_name => @unit.units_name,
                                         :units_type => @unit.units_type,
                                         :units_abbreviation => @unit.units_abbreviation)
      variable.units << unit
      variable.save
      site = Voeis::Site.get(params[:site].to_i)
      #create field measurments data_stream
      data_stream = Voeis::DataStream.first_or_create(:name => "Field Measurements-"+site.code,
                                                      :filename => "NA",
                                                      :start_line => -1,
                                                      :type => "Field Measurements")
      data_stream_column = Voeis::DataStreamColumn.first_or_create(:name => "FieldMeasurementColumn_"+variable.variable_code+'_'+site.code , 
                                                                   :type => "Na", 
                                                                   :unit => variable.units.first.units_name,  
                                                                   :original_var => variable.variable_name, 
                                                                   :column_number => -1)
      sensor_type = Voeis::SensorType.first_or_create(:name => "FieldMeasurement_"+variable.variable_code)
      sensor_value = Voeis::SensorValue.new(:value => params[:sensor_value].to_f,
                                               :string_value => params[:sensor_value],
                                               :units => variable.units.first.units_name,    
                                               :timestamp => d_time,  
                                               :vertical_offset => params[:vertical_offset])
      sensor_value.save
      sensor_type.sensor_values << sensor_value
      sensor_type.variables << variable
      sensor_type.save
      data_stream_column.sensor_types << sensor_type
      data_stream_column.save
      data_stream.data_stream_columns << data_stream_column
      data_stream.save
      site.data_streams << data_stream
      site.save
    end
    flash[:notice] = "Field Measurement was saved successfully."
    redirect_to new_field_measurement_project_sensor_values_path
  end
  
end
