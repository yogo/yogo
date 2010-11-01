# Sources
#
# The Sources table lists the original sources of the data, providing information sufficient to
# retrieve and reconstruct the data value from the original data files if necessary.
# The following rules and best practices should be followed when populating this table:
# * The SourceID field is the primary key, must be a unique integer, and cannot be NULL.
# This field should be implemented as an auto number/identity field.
# * The Organization field should contain a text description of the agency or organization
# that created the data.
# * The SourceDescription field should contain a more detailed description of where the data
# was actually obtained.
# * A default value of “Unknown” may be used for the source contact information fields in
# the event that this information is not known.
# * Each source must be associated with a metadata record in the ISOMetadata table.  As
# such, the MetadataID must reference a valid MetadataID from the ISOMetadata table.
# The ISOMetatadata table should be populated with an appropriate record prior to adding
# a source to the Sources table.  A default MetadataID of 0 can be used for a source with
# unknown or uninitialized metadata.
# * Use the Citation field to record the text that you would like others to use when they are
# referencing your data.  Where available, journal citations are encouraged to promote the
# correct crediting for use of data.
#
class His::Source
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "sources"

  property :id,                 Serial
  property :organization,       String,  :required => true                      , :format => /[^\t|\n|\r]/
  property :source_description, String,  :required => true
  property :source_link,        String
  property :contact_name,       String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :phone,              String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :email,              String,  :required => true, :default => "Unkown", :format => :email_address
  property :address,            String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :city,               String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :state,              String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :zip_code,           String,  :required => true, :default => "Unkown", :format => /[^\t|\n|\r]/
  property :citation,           String,  :required => true, :default => "Unkown"
  property :metadata_id,        Integer, :required => true, :default => 0

  has n,      :data_values,   :model => "His::DataValue"
  belongs_to  :iso_metadata,  :model => "His::ISOMetadata", :child_key => [:id]
end
