# SpatialReferenes
#
# ODM Design Specification - Description
# The SpatialReferences table provides information about the Spatial Reference Systems used for 
# latitude and longitude as well as local coordinate systems in the Sites table.  This table is a 
# controlled vocabulary. 
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class His::SpatialReferences
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id, Serial, :required => true, :key =>true, :field => "SpatialReferenceID"
  property :srs_id, Integer, :field => "SRSID"
  property :srs_name, String, :required => true, :field => "SRSName"
  property :is_geographic,  Integer, :field => "IsGeographic"
  property :notes, String, :field => "Notes"
  
  has n, :sites, :model => "His::Sites" #through LatLongDatumID and LocalProjectionID foriegn keys in Sites
  
  validates_with_method :srs_name, :method => :check_srs_name
  def check_srs_name
    check_ws_absence(self.srs_name, "SRSName")
  end
end