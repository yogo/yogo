# SpatialReferenes
#
# ODM Design Specification - Description
# The SpatialReferences table provides information about the Spatial Reference Systems used for
# latitude and longitude as well as local coordinate systems in the Sites table.  This table is a
# controlled vocabulary.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::SpatialReference
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "spatial_reference"

  property :id,             Serial
  property :srs_id,         Integer
  property :srs_name,       String,               :required => true, :format => /[^\t|\n|\r]/
  property :is_geographic,  Integer
  property :notes,          String

  has n, :sites, :model => "His::Site"
end