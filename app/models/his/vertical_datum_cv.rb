# VerticalDatumCV
#
# This is a "Monitoring Site Locations"
# The VerticalDatumCV table contains the controlled vocabulary for the VerticalDatum field in
# the Sites table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::VerticalDatumCV < His::Base
  storage_names[:his] = "vertical_datum_cv"

  property :term,       String, :key => true, :required => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n, :Sites, :model => "His::Site"
end
