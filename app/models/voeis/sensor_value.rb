# SensorValues
#

class Voeis::SensorValue
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :value,    Float,   :required => true
  property :units,    String,  :required => true
  property :timestamp,    DateTime,  :required => true, :index => true
  property :published,  Boolean, :required => false
  property :created_at,  DateTime
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :site,           :model => "Voeis::Site", :through => Resource
  has n, :sensor_type,    :model => "Voeis::SensorType", :through => Resource
  has n, :meta_tags,      :model => "Voeis::MetaTag", :through => Resource
  
  default_scope(:default).update(:order => [:timestamp]) # set default order

  def name
    self.sensor_type.name
  end

  # Returns the last updated sensor value
  def self.last_updated
    lu = first(:order => [:timestamp.desc])
    lu.timestamp unless lu.nil?
  end

  # This method allows us to do things like
  #    yogo_project_path(@project)
  # Instead of having to put @project.id
  def to_param
    self.name
  end
end