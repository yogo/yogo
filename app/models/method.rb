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
class Method
  include DataMapper::Resource

  property :id, Serial
  property :method_description, Text, :required => true
  property :method_link, String, :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  #has n, :sensor_types, :model => "SensorType", :through => Resource

end