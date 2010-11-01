# GroupDescriptions
#
# The GroupDescriptions table lists the descriptions for each of the groups of data values that
# have been formed.
# The following rules and best practices should be used in populating this table:
# * This table will only be populated if groups of data values have been created in the ODM
# database.
# * The GroupID field is the primary key, must be a unique integer, and cannot be NULL.  It
# should be implemented as an auto number/identity field.
# * The GroupDescription can be any text string that describes the group of observations.
#
class His::GroupDescription
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "group_descriptions"

  property :id,                 Serial
  property :group_description,  String

  has n, :groups, :model => "His::Group"
end