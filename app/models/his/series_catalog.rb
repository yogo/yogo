# SeriesCatalog
#
# The SeriesCatalog table lists each separate data series in the database for the purposes of
# identifying or displaying what data are available at each site and to speed simple queries without
# querying the main DataValues table.  Unique site/variable combinations are defined by unique
# combinations of SiteID, VariableID, MethodID, SourceID, and QualityControlLevelID.
# This entire table should be programmatically derived and should be updated every time data is
# added to the database.  Constraints on each field in the SeriesCatalog table are dependent upon
# the constraints on the fields in the table from which those fields originated.
#
class His::SeriesCatalog
  include DataMapper::Resource
  def self.default_repository_name
    :his
  end
  storage_names[:his] = "series_catalogs"

  property :SeriesID,                 Serial
  property :SiteID,                   Integer
  property :SiteCode,                 String
  property :SiteName,                 String
  property :VariableID,               Integer
  property :VariableCode,             String
  property :VariableName,             String
  property :Speciation,               String
  property :VariableUnitsID,          Integer
  property :VariableUnitsName,        String
  property :SampleMedium,             String
  property :ValueType,                String
  property :TimeSupport,              Float
  property :TimeUnitsID,              Integer
  property :TimeUnitsName,            String
  property :DataType,                 String
  property :GeneralCategory,          String
  property :MethodID,                 Integer
  property :MethodDescription,        String
  property :SourceID,                 Integer
  property :Organization,             String
  property :SourceDescription,        String
  property :Citation,                 String
  property :QualityControlLevelID,    Integer
  property :QualityControlLevelCode,  String
  property :BeginDateTime,            DateTime
  property :EndDateTime,              DateTime
  property :BeginDateTimeUTC,         DateTime
  property :EndDateTimeUTC,           DateTime
  property :ValueCount,               Integer
end