# SensorValues
#

class SensorValue
  include DataMapper::Resource
  
  property :id,       Serial,  :key      => true
  #property :name,     String,  :required => true
  property :value,    Float,   :required => true
  property :units,    String,  :required => true 
  property :timestamp,    DateTime,  :required => true, :index => true
  property :created_at,  DateTime
  property :published,  Boolean, :required => true, :default => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  
  has n, :site, :through => Resource  
  has n, :sensor_type, :model => "SensorType", :through => Resource

  default_scope(:default).update(:order => [:timestamp]) # set default order

  def name
    self.sensor_type.name
  end
  
  # Returns the last updated sensor value
  def self.last_updated
    lu = first(:order => [:timestamp.desc])
    lu.timestamp unless lu.nil?
  end
  
end