# Samples
#
# This is a "Data Collection Methods"
# The Samples table gives information about physical samples analyzed in a laboratory.
# The following rules and best practices should be followed when populating this table:
# * This table will only be populated if data values associated with physical samples are
# added to the ODM database.
# * The SamplID field is the primary key, must be a unique integer, and cannot be NULL.
# This field should be implemented as an auto number/identity field.
# * The SampleType field should be populated using terms from the SampleTypeCV table.
# Where the sample type is unknown, a default value of “Unknown” can be used.
# * The LabSampleCode should be a unique text code used by the laboratory to identify the
# sample.  This field is an alternate key for this table and should be unique.
# * The LabMethodID must reference a valid LabMethodID from the LabMethods table.
# The LabMethods table should be populated with the appropriate laboratory method
# information prior to adding records to this table that reference that laboratory method. A
# default value of 0 for this field indicates that nothing is known about the laboratory
# method used to analyze the sample.
#
class His::Sample < His::Base
  storage_names[:his] = "samples"

  property :id,               Serial
  property :sample_type,      String,   :required => true, :default => 'Unknown'
  property :lab_sample_code,  String,   :required => true,                        :format => /[^\t|\n|\r]/
  property :lab_method_id,    Integer,  :required => true, :default => 0

  has n,     :data_values,    :model => "His::DataValue"
  belongs_to :sample_type_cv, :model => "His::SampleTypeCV",  :child_key => [:sample_type]
  belongs_to :lab_methods,    :model => "His::LabMethod",     :child_key => [:lab_method_id]
end
