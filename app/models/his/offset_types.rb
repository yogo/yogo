# OffsetTypes
#
# The OffsetTypes table lists full descriptive information for each of the measurement offsets. 
# The following rules and best practices should be followed when populating this table: 
# * Although all three fields in this table are mandatory, this table will only be populated if 
# data values measured at an offset have been entered into the ODM database.   
# * The OffsetTypeID field is the primary key, must be a unique integer, and cannot be 
# NULL.  This field should be implemented as an auto number/identity field. 
# * The OffsetUnitsID field should reference a valid ID from the UnitsID field in the Units 
# table.  Because the Units table is a controlled vocabulary, only units that already exist in 
# the Units table can be used as the units of the offset. 
# * The OffsetDescription field should be filled in with a complete text description of the 
# offset that provides enough information to interpret the type of offset being used.  For 
# example, “Distance from stream bank” is ambiguous because it is not known which bank 
# is being referred to.   
# 
class His::OffsetTypes
  include DataMapper::Resource
  
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id, Serial, :required => true, :key => true, :field => "OffsetTypeID"
  property :offset_units_id, Integer, :required => true, :field => "OffsetUnitsID"
  property :offset_description, String, :required => true, :field => "OffsetDescription"

  has n, :data_values, :model => "His::DataValues"
  belongs_to :Units, :model => "His::Units", :child_key => [:offset_units_id]

end