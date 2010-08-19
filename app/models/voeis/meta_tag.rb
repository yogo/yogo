class Voeis::MetaTag
  include DataMapper::Resource
  extend Yogo::DataMapper::Model::StorageContext
  property :id, UUID,       :key => true, :default => lambda { UUIDTools::UUID.timestamp_create }
  #property :name,     String,  :required => true
  property :value,    Text,   :required => true
  property :name,    String,  :required => true
  property :created_at,  DateTime

  has n, :sensor_values, :model => 'Voeis::SensorValue', :through => Resource

end