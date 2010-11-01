# SpeciatonCV
#
# The SpeciationCV table contains the controlled vocabulary for the Speciation field in the
# Variables table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::SpeciationCV
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "speciation_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n,   :variables, :model => "His::Variable"
end