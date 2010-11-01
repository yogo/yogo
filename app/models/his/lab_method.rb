# LabMethods
#
# This is a "Data Collection Methods"
# The LabMethods table contains descriptions of the laboratory methods used to analyze physical
# samples for specific constituents.
# The following rules and best practices should be used when populating this table:
# * The LabMethodID field is the primary key, must be a unique integer, and cannot be
# NULL.  It should be implemented as an auto number/identity field.
# * All of the fields in this table are required and cannot be null except for the
# LabMethodLink.
# * The default value for all of the required fields except for the LabMethodID is
# “Unknown.”
# * A single record should exist in this table where the LabMethodID = 0 and the LabName,
# LabOrganization, LabMethdodName, and LabMethodDescription fields are equal to
# “Unknown” and the LabMethodLink = NULL.  This record should be used to identify
# samples in the Samples table for which nothing is known about the laboratory method
# used to analyze the sample.
#
class His::LabMethod
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "lab_methods"

  property :id,                     Serial
  property :lab_name,               String, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_organization,       String, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_method_name,        String, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_method_description, String, :required => true, :default => 'Unknown'
  property :lab_method_link,        String

  has n, :samples, :model => "His::Sample"
end