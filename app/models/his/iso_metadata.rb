# ISOMetadata
#
# This is a "Data Sources"
# The ISOMetadata table contains dataset and project level metadata required by the CUAHSI HIS
# metadata system (http://www.cuahsi.org/his/documentation.html) for compliance with standards
# such as the draft ISO 19115 or ISO 8601.  The mandatory fields in this table must be populated
# to provide a complete set of ISO compliant metadata in the database.
# The following rules and best practices should be used in populating this table:
# * The MetadataID field is the primary key, must be a unique integer, and cannot be NULL.
# This field should be implemented as an auto number/identity field.
# * All of the fields in this table are mandatory and cannot be NULL except for the
# MetadataLink field.
# * The TopicCategory field should only be populated with terms from the
# TopicCategoryCV table.  The default controlled vocabulary term is “Unknown.”
# * The Title field should be populated with a brief text description of what the referenced
# data represent.  This field can be populated with “Unknown” if there is no title for the
# data.
# * The Abstract field should be populated with a more complete text description of the data
# that the metadata record references. This field can be populated with “Unknown” if there
# is no abstract for the data.
# * The ProfileVersion field should be populated with the version of the ISO metadata profile
# that is being used.  This field can be populated with “Unknown” if there is no profile
# version for the data.
# * One record with a MetadataID = 0 should exist in this table with TopicCategory, Title,
# Abstract, and ProfileVersion = “Unknown” and MetadataLink = NULL.  This record
# should be the default value for sources with unknown/unspecified metadata.
#
class His::ISOMetadata 
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "iso_meta_data"

  property :id,               Serial
  property :topic_category,   String, :required => true, :default => 'Unknown'
  property :title,            String, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :abstract,         String, :required => true, :default => 'Unknown'
  property :profile_version,  String, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
  property :metadata_link,    String

  belongs_to  :topic_category_cv, :model => "His::TopicCategoryCV", :child_key => [:topic_category]
  has n,      :sources,           :model => "His::Source"
end