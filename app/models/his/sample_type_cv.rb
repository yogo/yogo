# SampleTypeCV
#
# This is a "Data Collection Methods"
# The SampleMediumCV table contains the controlled vocabulary for sample media.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::SampleTypeCV < His::Base
  storage_names[:his] = "sample_type_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n,   :samples,    :model => "His::Sample"
end
