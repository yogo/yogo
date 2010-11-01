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
class His::Site
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "sites"

  property :id,                  Serial
  property :site_code,           String,  :required => true,                :unique => true
  property :site_name,           String,  :required => true, :length => 256
  property :latitude,            Float,   :required => true
  property :longitude,           Float,   :required => true
  property :lat_long_datum_id,   Integer, :required => true, :default => 0
  property :elevation_m,         Float,   :required => false
  property :vertical_datum,      String,  :required => false
  property :local_x,             Float,   :required => false
  property :local_y,             Float,   :required => false
  property :local_projection_id, Integer, :required => false
  property :pos_accuracy_m,      Float,   :required => false
  property :state,               String,  :required => true
  property :county,              String,  :required => false
  property :comments,            String,  :required => false

  has n,     :data_values,        :model => "His::DataValue"
  belongs_to :vertical_datum_cv,  :model => "His::VerticalDatumCV",   :child_key => [:vertical_datum]
  belongs_to :spatial_references, :model => "His::SpatialReference",  :child_key => [:lat_long_datum_id, :local_projection_id] #is this going to work?
end
