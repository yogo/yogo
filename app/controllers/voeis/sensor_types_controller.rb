class Voeis::SensorTypesController < Voeis::BaseController
  
  # Properly override defaults to ensure proper controller behavior
  # @see Voeis::BaseController
  defaults  :route_collection_name => 'sensor_types',
            :route_instance_name => 'sensor_type',
            :collection_name => 'sensor_types',
            :instance_name => 'sensor_type',
            :resource_class => Voeis::SensorType
  
end
