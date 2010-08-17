# SensorValues
#
require 'yogo/datamapper/model/storage_context'

class SensorValue
  include DataMapper::Resource
  extend Yogo::DataMapper::Model::StorageContext

  property :id,       Serial,  :key      => true
  property :value,    Float,   :required => true
  property :units,    String,  :required => true
  property :timestamp,    DateTime,  :required => true, :index => true
  property :created_at,  DateTime

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

  # This method allows us to do things like
  #    yogo_project_path(@project)
  # Instead of having to put @project.id
  def to_param
    self.name
  end
end