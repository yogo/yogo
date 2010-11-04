# SensorValues
#

class SensorType
  include DataMapper::Resource

  
  property :id,       Serial,  :key      => true
  property :name,     String,  :required => true
  property :min,      Integer,  :required => false
  property :max,      Integer,  :required => false
  property :difference,  Integer,  :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :sites, :through => Resource
  has n, :sensor_values, :model => "SensorValue", :through => Resource
  has n, :variables, :through => Resource
  #has n, :methods, :model => "Method", :through => Resource
  
end