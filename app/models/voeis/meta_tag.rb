class Voeis::MetaTag
  include DataMapper::Resource

  property :id,       Serial,  :key      => true
  #property :name,     String,  :required => true
  property :value,    Text,   :required => true
  property :name,    String,  :required => true
  property :created_at,  DateTime

  has n, :sensor_values, :model => 'Voeis::SensorValue', :through => Resource

end