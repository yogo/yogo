# ValueTypeCV
#
# The ValueTypeCV table contains the controlled vocabulary for the ValueType field in the
# Variables and SeriesCatalog tables.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
#
class His::ValueTypeCV < His::Base
  storage_names[:his] = "value_type_cvs"

  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String

  has n,   :variables, :model => "His::Variable"
end
