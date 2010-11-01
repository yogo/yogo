# DataTypeCV
#
# The DataTypeCV table contains the controlled vocabulary for data types.  Only values from the
# Term field in this table can be used to populate the DataType field in the Variables table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::DataTypeCV
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "data_type_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n, :variables, :model => "His::Variable"
end