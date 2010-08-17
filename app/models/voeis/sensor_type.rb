# SensorTypes

class SensorType
  include DataMapper::Resource


  property :id,       Serial,  :key      => true
  property :name,     String,  :required => true
  property :min,      Integer,  :required => false
  property :max,      Integer,  :required => false
  property :difference,  Integer,  :required => false

  has n, :sites, :through => Resource
  has n, :sensor_values, :model => "SensorValue", :through => Resource
  has n, :variables, :through => Resource
  #has n, :methods, :model => "Method", :through => Resource

  # This method allows us to do things like
  #    yogo_project_path(@project)
  # Instead of having to put @project.id
  def to_param
    self.name
  end
end