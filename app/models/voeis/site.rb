# Sites TODO- validate the best practices below
#
# This is a "Monitoring Site Locations"
# The Sites table provides information giving the spatial location at which data values have been
# collected.
# The following rules and best practices should be followed when populating this table:
# * The SiteID field is the primary key, must be a unique integer, and cannot be NULL.  This
# field should be implemented as an auto number/identity field.
# * The SiteCode field must contain a text code that uniquely identifies each site.  The values
# in this field should be unique and can be an alternate key for the table.  SiteCodes cannot
# contain any characters other than A-Z (case insensitive), 0-9, period “.”, dash “-“, and
# underscore “_”.
# * The LatLongDatumID must reference a valid SpatialReferenceID from the
# SpatialReferences controlled vocabulary table.  If the datum is unknown, a default value
# of 0 is used.
# * If the Elevation_m field is populated with a numeric value, a value must be specified in
# the VerticalDatum field.  The VerticalDatum field can only be populated using terms
# from the VerticalDatumCV table.  If the vertical datum is unknown, a value of
# “Unknown” is used.
# * If the LocalX and LocalY fields are populated with numeric values, a value must be
# specified in the LocalProjectionID field.  The LocalProjectionID must reference a valid
# SpatialReferenceID from the SpatialReferences controlled vocabulary table.  If the spatial
# reference system of the local coordinates is unknown, a default value of 0 is used.
#

class Voeis::Site
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :code, String, :required => true
  property :name, String, :required => true, :length => 512
  property :latitude, Float, :required => true
  property :longitude, Float, :required => true
  property :lat_long_datum_id, Integer, :required => false, :default => 0
  property :elevation_m, Float, :required => false
  property :vertical_datum, String, :required => false
  property :local_x, Float,  :required => false
  property :local_y, Float, :required => false
  property :local_projection_id, Integer, :required => false
  property :pos_accuracy_m, Float, :required => false
  property :state, String, :required => true
  property :county, String, :required => false
  property :comments, Text, :required => false
  property :description, Text, :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now
  property :time_zone_offset, String, :required => false, :default => "unknown"
  is_versioned :on => :updated_at
  
  validates_uniqueness_of :code
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  
  # has n, :projects, :through => Resource
  has n, :data_streams, :model => "Voeis::DataStream", :through => Resource
  has n, :sensor_types,    :model => "Voeis::SensorType", :through => Resource
  #has n, :sensor_values,  :model => "Voeis::SensorValue", :through => Resource
  has n, :data_values,  :model => "Voeis::DataValue", :through => Resource
  has n, :samples,  :model => "Voeis::Sample", :through => Resource
  has n, :variables, :model => "Voeis::Variable", :through => Resource
  
  def fetch_time_zone
    require 'net/http'
    require 'rexml/document'
    connection = Net::HTTP.new("www.earthtools.org")
    response = ""
    connection.start do |http|
      req = Net::HTTP::Get.new("/timezone-1.1/40.71417/-74.00639")
      response = http.request(req)
    end
    doc = REXML::Document.new(response.body)
    self.time_zone_offset = doc.elements["timezone/offset"].text
    self.save
  end
  
end