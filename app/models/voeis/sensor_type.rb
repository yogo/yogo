
# SensorTypes
#

class Voeis::SensorType
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id,          Serial
  property :name,        String,  :required => true, :length => 512
  property :min,         Float,  :required => false
  property :max,         Float,  :required => false
  property :difference,  Float,  :required => false

  property :created_at, DateTime
  property :updated_at, DateTime

  is_versioned :on => :updated_at

  has n, :sites,          :model => "Voeis::Site", :through => Resource
  has n, :data_stream_columns, :model => 'Voeis::DataStreamColumn', :through => Resource
  has n, :sensor_type_sensor_values, :model => 'Voeis::SensorTypeSensorValue'
  has n, :sensor_values,   :through => :sensor_type_sensor_value
  has n, :variables,      :model => "Voeis::Variable", :through => Resource

end