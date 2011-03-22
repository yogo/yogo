# Variables
#
# This is apart of "Variables"
# The Variables table lists the full descriptive information about what variables have been
# measured.
# The following rules and best practices should be followed when populating this table:
# * The VariableID field is the primary key, must be a unique integer, and cannot be NULL.
# This field should be implemented as an auto number/identity field.
# * The VariableCode field must be unique and serves as an alternate key for this table.
# Variable codes can be arbitrary, or they can use an organized system.  VaraibleCodes
# cannot contain any characters other than A-Z (case insensitive), 0-9, period “.”, dash “-“,
# and underscore “_”.
# * The VariableName field must reference a valid Term from the VariableNameCV
# controlled vocabulary table.
# * The Speciation field must reference a valid Term from the SpeciationCV controlled
# vocabulary table.  A default value of “Not Applicable” is used where speciation does not
# apply.  If the speciation is unknown, a value of “Unknown” can be used.
# * The VariableUnitsID field must reference a valid UnitsID from the UnitsTable controlled
# vocabulary table.
# * Only terms from the SampleMediumCV table can be used to populate the
# SampleMedium field.  A default value of “Unknown” is used where the sample medium
# is unknown.
# * Only terms from the ValueTypeCV table can be used to populate the ValueType field.  A
# default value of “Unknown” is used where the value type is unknown.
# * The default for the TimeSupport field is 0.  This corresponds to instantaneous values.  If
# the TimeSupport field is set to a value other than 0, an appropriate TimeUnitsID must be
# specified.  The TimeUnitsID field can only reference valid UnitsID values from the Units
# controlled vocabulary table.  If the TimeSupport field is set to 0, any time units can be
# used (i.e., seconds, minutes, hours, etc.), however a default value of 103 has been used,
# which corresponds with hours.
# * Only terms from the DataTypeCV table can be used to populated the DataType field.  A
# default value of “Unknown” can be used where the data type is unknown.
# * Only terms from the GeneralCategoryCV table can be used to populate the
# GeneralCategory field.  A default value of “Unknown” can be used where the general
# category is unknown.
# * The NoDataValue should be set such that it will never conflict with a real observation
# value.  For example a NoDataValue of -9999 is valid for water temperature because we
# would never expect to measure a water temperature of -9999.  The default value for this
# field is -9999.

class Voeis::Variable
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :variable_code, String, :required => true, :length => 512
  property :variable_name, String, :required => true, :length => 512
  property :speciation, String, :required => true, :default => 'Not Applicable', :length => 512
  property :variable_units_id, Integer, :required => true
  property :sample_medium, String, :required => true, :default => 'Unknown', :length => 512
  property :value_type, String, :required => true, :default =>'Unknown', :length => 512
  property :is_regular, Boolean, :required => true, :default => false
  property :time_support, Float, :required => true, :default => 1.0
  property :time_units_id, Integer, :required => true, :default => 103
  property :data_type, String, :required => true, :default => 'Unknown', :length => 512
  property :general_category, String, :required => true, :default => 'Unknown', :length => 512
  property :no_data_value, Float, :required => true, :default => -9999
  #property :limit_of_detection, Float, :required => false
  property :updated_at, DateTime, :required => true,  :default => DateTime.now
  property :detection_limit,   Float,   :required => false
  
  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :data_stream_columns,      :model => "Voeis::DataStreamColumn", :through => Resource
  has n, :sensor_types,             :model => "Voeis::SensorType", :through => Resource
  has n, :units,                    :model => "Voeis::Unit", :through => Resource
  has n, :data_values,  :model => "Voeis::DataValue", :through => Resource
  has n, :sites, :model => "Voeis::Site", :through => Resource
  has n, :samples, :model => "Voeis::Sample", :through => Resource
  
  def self.store_from_his(his_v)
        self.create(
                    :variable_name => his_v.variable_name,
                    :variable_code => his_v.variable_code,
                    :speciation => his_v.speciation,
                    :variable_units_id => his_v.variable_units_id,
                    :sample_medium => his_v.sample_medium,
                    :value_type => his_v.value_type,
                    :is_regular => his_v.is_regular,
                    :time_support => his_v.time_support,
                    :time_units_id => his_v.time_units_id,
                    :data_type => his_v.data_type,
                    :general_category => his_v.general_category,
                    :no_data_value => his_v.no_data_value)
  end
end