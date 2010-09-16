# Qualifiers
#
# This is a "Data Qualifier"
# The Qualifiers table contains data qualifying comments that accompany the data.
# This table will only be populated if data values that have data qualifying comments have been
# added to the ODM database.  The following rules and best practices should be used when
# populating this table:
# * The QualifierID field is the primary key, must be a unique integer, and cannot be NULL.
# This field should be implemented as an auto number/identity field.
#
class His::Qualifier < His::Base
  storage_names[:his] = "qualifiers"

  property :id,                    Serial
  property :qualifier_code,        String
  property :qualifier_description, String, :required => true

  has n, :data_values, :model => "His::DataValue"
end
