# GeneralCategoryCV
#
# The GeneralCategoryCV table contains the controlled vocabulary for the general categories
# associated with Variables.  The GeneralCategory field in the Variables table can only be
# populated with values from the Term field of this controlled vocabulary table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::GeneralCategoryCV
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "general_category_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n, :variables, :model => "His::Variable"
end