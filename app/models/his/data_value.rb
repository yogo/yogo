# DataValues
#
# This is a "Obersvations Values"
# The DataValues table contains the actual data values.
# The following rules and best practices should be used in populating this table:
# * ValueID is the primary key, is mandatory, and cannot be NULL.  This field should be
# implemented as an autonumber/identity field.  When data values are added to this table, a
# unique integer ValueID should be assigned to each data value by the database software
# such that the primary key constraint is not violated.
# * Each record in this table must be unique.  This is enforced by a unique constraint across
# all of the fields in this table (excluding ValueID) so that duplicate records are avoided.
# * The LocalDateTime, UTCOffset, and DateTimeUTC must all be populated.  Care must
# be taken to ensure that the correct UTCOffset is used, especially in areas that observe
# daylight saving time.  If LocalDateTime and DateTimeUTC are given, the UTCOffset
# can be calculated as the difference between the two dates.  If LocalDateTime and
# UTCOffset are given, DateTimeUTC can be calculated.
# * SiteID must correspond to a valid SiteID from the Sites table.  When adding data for a
# new site to the ODM, the Sites table should be populated prior to adding data values to
# the DataValues table.
# * VariableID must correspond to a valid VariableID from the Variables table.  When
# adding data for a new variable to the ODM, the Variables table should be populated prior
# to adding data values for the new variable to the DataValues table.
# * OffsetValue and OffsetTypeID are optional because not all data values have an offset.
# Where no offset is used, both of these fields should be set to NULL indicating that the
# data values do not have an offset.  Where an OffsetValue is specified, an OffsetTypeID
# must also be specified and it must refer to a valid OffsetTypeID in the OffsetTypes table.
# The OffsetTypes table should be populated prior to adding data values with a particular
# OffsetTypeID to the DataValues table.
# * CensorCode is mandatory and cannot be NULL.  A default value of “nc” is used for this
# field.  Only Terms from the CensorCodeCV table should be used to populate this field.
# * The QualifierID field is optional because not all data values have qualifiers.  Where no
# qualifier applies, this field should be set to NULL.  When a QualifierID is specified in
# this field it must refer to a valid QualifierID in the Qualifiers table.  The Qualifiers table
# should be populated prior to adding data values with a particular QualifierID to the
# DataValues Table.
# * MethodID must correspond to a valid MethodID from the Methods table and cannot be
# NULL.  A default value of 0 is used in the case where no method is specified or the
# method used to create the observation is unknown.  The Methods table should be
# populated prior to adding data values with a particular MethodID to the DataValues table.
# * SourceID must correspond to a valid SourceID from the Sources table and cannot be
# NULL.  The Sources table should be populated prior to adding data values with a
# particular SourceID to the DataValues table.
# * SampleID is optional and should only be populated if the data value was generated from
# a physical sample that was sent to a laboratory for analysis.  The SampleID must
# correspond to a valid SampleID in the Samples table, and the Samples table should be
# populated prior to adding data values with a particular SampleID to the DataValues table.
# * DerivedFromID is optional and should only be populated if the data value was derived
# from other data values that are also stored in the ODM database.
# * QualityControlLevelID is mandatory, cannot be NULL, and must correspond to a valid
# QualityControlLevelID in the QualityControlLevels table.  A default value of -9999 is
# used for this field in the event that the QualityControlLevelID is unknown.  The
# QualityControlLevels table should be populated prior to adding data values with a
# particular QualityControlLevelID to the DataValues table.
#
class His::DataValue
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "data_values"

  property :id,                       Serial
  property :data_value,               Float,    :required => true,  :default => 0
  property :value_accuracy,           Float
  property :local_date_time,          DateTime, :required => true,  :default => DateTime.now
  property :utc_offset,               Float,    :required => true,  :default => 1.0
  property :date_time_utc,            DateTime, :required => true,  :default => "2009-12-01T02:00:00+00:00"
  property :site_id,                  Integer,  :required => true,  :default => 1
  property :variable_id,              Integer,  :required => true,  :default => 1
  property :offset_value,             Float
  property :offset_type_id,           Integer
  property :censor_code,              String,   :required => true,  :default => 'nc'
  property :qualifier_id,             Integer
  property :method_id,                Integer,  :required => true,  :default => 0
  property :source_id,                Integer,  :required => true,  :default => 1
  property :sample_id,                Integer
  property :derived_from_id,          Integer
  property :quality_control_level_id, Integer,  :required => true,  :default => -9999
end