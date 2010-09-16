# CensorCodeCV
#
# This is a "Observations Value"
# The CensorCodeCV table contains the controlled vocabulary for censor codes.  Only values from
# the Term field in this table can be used to populate the CensorCode field of the DataValues table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class His::CensorCodeCV < His::Base
  storage_names[:his] = "censor_code_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n,  :DataValues, :model => "His::DataValue"
end
