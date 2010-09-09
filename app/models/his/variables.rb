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
#
class His::Variables
  include DataMapper::Resource
  include Odhelper

  def self.default_repository_name
    :his_rest
  end

  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end

  property :id,               Serial, :required => true, :key => true, :field => "VariableID"
  property :variable_code,    String, :required => true, :field => "VariableCode"
  property :variable_name,    String, :required => true, :field => "VariableName"
  property :speciation,       String, :required => true, :default => 'Not Applicable', :field => "Speciation"
  property :variable_units_id,Integer,:required => true, :field => "VariableUnitsID"
  property :sample_medium,    String, :required => true, :default => 'Unknown', :field => "SampleMedium"
  property :value_type,       String, :required => true, :default =>'Unknown', :field => "ValueType"
  property :is_regular,       Integer,:required => true, :default => 0, :field => "IsRegular"
  property :time_support,     Float,  :required => true, :field => "TimeSupport"
  property :time_units_id,    Integer,:required => true, :default => 103, :field => "TimeUnitsID"
  property :data_type,        String, :required => true, :default => 'Unknown', :field => "DataType"
  property :general_category, String, :required => true, :default => 'Unknown', :field => "GeneralCategory"
  property :no_data_value,    Float,  :required => true, :default => -9999, :field => "NoDataValue"

  has n, :Categories,               :model => "His::Categories"
  belongs_to :units,                :model => "His::Units", :child_key => [:time_units_id, :variable_units_id] #will this work?
  belongs_to :data_type_cv,         :model => "His::DataTypeCV", :child_key => [:data_type]
  belongs_to :general_category_cv,  :model => "His::GeneralCategoryCV", :child_key => [:general_category]
  belongs_to :sample_medium_cv,     :model => "His::SampleMediumCV", :child_key => [:sample_medium]
  belongs_to :value_type_cv,        :model => "His::ValueTypeCV", :child_key => [:value_type]
  belongs_to :variable_name_cv,     :model => "His::VariableNameCV", :child_key => [:variable_name]
  belongs_to :speciation_cv,        :model => "His::SpeciationCV", :child_key => [:speciation]
  belongs_to :data_values,          :model => "His::DataValues", :child_key => [:varialbe_id]

  validates_uniqueness_of :variable_code

  validates_with_method :variable_code, :method => :check_variable_code
  def check_variable_code
    check_ws_absence(self.variable_code, "VariableCode")
  end
end