# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and 
# offsets.  This is a controlled vocabulary table. 
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class His::Units
  include DataMapper::Resource
  include Odhelper
  
  def self.default_repository_name
    :his
  end
  
  def self.storage_name(repository_name)
    return self.name.gsub(/.+::/, '')
  end
  
  property :id, Serial, :required => true, :key =>true, :field => "UnitsID"
  property :units_name, String, :required => true, :field => "UnitsName"
  property :units_type, String, :required => true, :field => "UnitsType"
  property :units_abbreviation, String, :required => true, :field => "UnitsAbbreviation"
  
  has n, :variables, :model => "His::Variables"
  has n, :offset_types, :model => "His::OffsetTypes"
  
  validates_with_method :units_name, :method => :check_units_name
  def check_units_name
    check_ws_absence(self.units_name, "UnitsName")
  end

  validates_with_method :units_type, :method => :check_units_type
  def check_units_type
    check_ws_absence(self.units_type, "UnitsType")
  end

  validates_with_method :units_abbreviation, :method => :check_units_abbreviation
  def check_units_abbreviation
    check_ws_absence(self.units_abbreviation, "UnitsAbbreviation")
  end
end