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
class Voeis::LabMethod
  include DataMapper::Resource
  include Facet::DataMapper::Resource
  
  property :id,                     Serial
  property :lab_name,               Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_organization,       Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_method_name,        Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :lab_method_description, Text, :required => true, :default => 'Unknown'
  property :lab_method_link,        Text
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  
  has n, :samples, :model => "Voeis::Sample", :through => Resource
  
end