# DerivedFrom
#
# ODM Design Specification - Description
# The DerivedFrom table contains the linkage between derived data values and the data values that
# they were derived from.
# The following rules and best practices should be used in populating this table:
# * Although all of the fields in this table are mandatory, they need only be populated if
# derived data values and the data values that they were derived from are entered into the
# database.  If there are no derived data in the DataValues table, this table will be empty.
#
class His::DerivedFrom
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "derived_from"

  property :derived_from_id,  Integer, :required => true, :key=>true
  property :value_id,         Integer, :required => true
end
