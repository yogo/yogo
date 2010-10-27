
# SensorTypes
#

class Voeis::SensorType
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :name,     String,  :required => true, :length => 512
  property :min,      Float,  :required => false
  property :max,      Float,  :required => false
  property :difference,  Float,  :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :sites,          :model => "Voeis::Site", :through => Resource
  has n, :data_stream_columns, :model => 'Voeis::DataStreamColumn', :through => Resource
  has n, :sensor_values,  :model => "Voeis::SensorValue", :through => Resource
  has n, :variables,      :model => "Voeis::Variable", :through => Resource
  #has n, :methods, :model => "Method", :through => Resource

  # This method allows us to do things like
  #    yogo_project_path(@project)
  # Instead of having to put @project.id
  def to_param
    self.name
  end
end