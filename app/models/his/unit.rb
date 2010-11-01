# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and
# offsets.  This is a controlled vocabulary table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::Unit
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "units"

  property :id,                 Serial
  property :units_name,         String, :required => true, :format => /[^\t|\n|\r]/
  property :units_type,         String, :required => true, :format => /[^\t|\n|\r]/
  property :units_abbreviation, String, :required => true, :format => /[^\t|\n|\r]/

  has n, :variables,    :model => "His::Variable"
  has n, :offset_types, :model => "His::OffsetType"
end