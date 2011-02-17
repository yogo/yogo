class Voeis::SensorValuesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'sensor_values',
            :route_instance_name => 'sensor_value',
            :collection_name => 'sensor_values',
            :instance_name => 'sensor_value',
            :resource_class => Voeis::SensorValue
  
  def new
      @sites = parent.managed_repository{Voeis::Site.all}
      @variables = Variable.all
      @units = Unit.all
  end
end
