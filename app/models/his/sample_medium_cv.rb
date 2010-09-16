# SampleMediumCV
#
# This is a "Varialble"
# The SampleMediumCV table contains the controlled vocabulary for sample media.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::SampleMediumCV < His::Base
  storage_names[:his] = "sample_medium_cvs"

  property :term,       String, :required => true, :key => true
  property :definition, String

  has n,   :samples,    :model => "His::Sample"
end
