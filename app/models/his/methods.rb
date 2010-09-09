# Methods
# 
# This is a "Data Collection Methods
# The Methods table lists the methods used to collect the data and any additional information about 
# the method. 
# The following rules and best practices should be used when populating this table: 
# * The MethodID field is the primary key, must be a unique integer, and cannot be NULL.  
# * There is no default value for the MethodDescription field in this table.  Rather, this table 
# should contain a record with MethodID = 0, MethodDescription = “Unknown”, and 
# MethodLink = NULL.  A MethodID of 0 should be used as the MethodID for any data 
# values for which the method used to create the value is unknown (i.e., the default value 
# for the MethodID field in the DataValues table is 0). 
# * Methods should describe the manner in which the observation was collected (i.e., 
# collected manually, or collected using an automated sampler) or measured (i.e., measured 
# using a temperature sensor or measured using a turbidity sensor).  Details about the 
# specific sensor models and manufacturers can be included in the MethodDescription. 
# 
class His::Methods
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his_rest
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id, Serial, :required => true, :key => true, :field => "MethodID"
  property :method_description, String, :required => true, :field => "MethodDescription"
  #property :method_link, String, :field => "MethodLink",:required => false

  #has n,  :data_values, :class_name => "His::DataValues"
end