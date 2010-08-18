# QualityControlLevels
# 
# This is a Data Qualifier
# The QualityControlLevels table contains the quality control levels that are used for versioning 
# data within the database.  
# This table is pre-populated with quality control levels 0 through 4 within the ODM.  The 
# following rules and best practices should be used when populating this table: 
# * The QualityControlLevelID field is the primary key, must be a unique integer, and cannot 
# be NULL.  This field should be implemented as an auto number/identity field. 
# * It is suggested that the pre-populated system of quality control level codes (i.e., 
# QualityControlLevelCodes 0 – 4) be used.  If the pre-populated list is not sufficient, new 
# quality control levels can be defined.  A quality control level code of -9999 is suggested 
# for data whose quality control level is unknown. 
# 
class His::QualityControlLevels
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id, Serial, :required => true, :key => true, :field => "QualityControlLevelID"
  property :quality_control_level_code, String, :required => true, :field => "QualityControlLevelCode"
  property :definition, String, :required => true, :field => "Definition"
  property :explanation, String, :required => true, :field => "Explanation"

  has n, :data_values, :model => "His::DataValues"
  
 validates_with_method :quality_control_level_code, :method => :check_quality_control_level_code
  def check_quality_control_level_code
    check_ws_absence(self.quality_control_level_code, "QualityControlLevelCode")
  end
  
  validates_with_method :definition, :method => :check_definition
  def check_definition
    check_ws_absence(self.definition, "Definition")
  end
end