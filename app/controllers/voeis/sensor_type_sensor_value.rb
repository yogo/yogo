class Voeis::SensorTypeSensorValue
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :sensor_type_id, Integer, :required => true, :key => true
  property :sensor_value_id, Integer, :required => true, :key => true
  property :sensor_value_timsestamp, DateTime, :required => false
  property :sensor_value_sensor_id, Integer, :required => false

  belongs_to :sensor_type,  :model => "Voeis::SensorType", :parent_key => [:id], :child_key => [:sensor_type_id]
  belongs_to :sensor_value, :model => "Voeis::SensorValue",  :parent_key => [:id], :child_key => [:sensor_value_id]
end