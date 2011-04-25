# QualityControlLevels
#
# This is a Data Qualifier
# The QualityControlLevels table contains the quality control levels that are used for versioning
# data within the database.
# This table is pre-populated with quality control levels 0 through 4 within the ODM.  The
# following rules and best practices should be used when populating this table:
# * The QualityControlLevelID field is the primary key, must be a unique integer, and cannot
# be NULL.  This field should be implemented as an auto number/identity field.
# * It is suggested that the pre-populated system of quality control level codes (i.e.,
# QualityControlLevelCodes 0 – 4) be used.  If the pre-populated list is not sufficient, new
# quality control levels can be defined.  A quality control level code of -9999 is suggested
# for data whose quality control level is unknown.
#
class His::QualityControlLevel
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "quality_control_levels"

  property :id,                         Serial
  property :quality_control_level_code, String, :required => true, :format => /[^\t|\n|\r]/
  property :definition,                 String, :required => true, :format => /[^\t|\n|\r]/
  property :explanation,                String, :required => true
  
  has n,   :data_values,                :model => "His::DataValue"
end