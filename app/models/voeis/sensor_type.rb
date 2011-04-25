
# SensorTypes
#

class Voeis::SensorType
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,          Serial
  property :name,        String, :required => true, :length => 512
  property :min,         Float,  :required => false
  property :max,         Float,  :required => false
  property :difference,  Float,  :required => false

  yogo_versioned

  has n, :sites,                     :model => "Voeis::Site", :through => Resource
  has n, :data_stream_columns,       :model => 'Voeis::DataStreamColumn', :through => Resource
  has n, :sensor_values,             :model => "Voeis::SensorValue", :through => Resource
  has n, :variables,                 :model => "Voeis::Variable", :through => Resource

end
