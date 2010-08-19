# Categories
#
# This is a "Categorical Data"
# The Categories table defines the categories for categorical variables.  Records are required for 
# variables where DataType is specified as "Categorical."  Multiple entries for each VariableID, 
# with different DataValues provide the mapping from DataValue to category description.   
# The following rules and best practices should be used in populating this table: 
# * Although all of the fields in this table are mandatory, they need only be populated if 
# categorical data are entered into the database.  If there are no categorical data in the 
# DataValues table, this table will be empty. 
# * This table should be populated before categorical data values are added to the DataValues 
# table. 
#  
class His::Categories
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id,                   Integer,  :required => true, :key=>true, :field => "VariableID"
  property :data_value,           Float,    :required => true, :field => "DataValue"
  property :category_description, String,   :required => true, :field => "CategoryDescription"

  has n,      :data_values, :model => "His::DataValues"
  belongs_to  :variables,   :model => "His::Variables", :child_key => [:id]

end