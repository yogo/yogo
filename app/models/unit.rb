# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and 
# offsets.  This is a controlled vocabulary table. 
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be 
# requested at http://water.usu.edu/cuahsi/odm/. 
# 
class Unit
  include DataMapper::Resource
  

  
  property :id, Serial, :required => true, :key =>true
  property :units_name, String, :required => true
  property :units_type, String, :required => true
  property :units_abbreviation, String, :required => true
  
  has n, :data_stream_columns, :model=>"DataStreamColumn", :through =>Resource
  has n, :variables, :model =>"Variable", :through => Resource
  # has n, :OffsetTypes, :class_name => "Raw::OffsetTypes"
  # 
  # validates_with_method :units_name, :method => :check_units_name
  # def check_units_name
  #   check_ws_absence(self.units_name, "units_name")
  # end
  # 
  # validates_with_method :units_type, :method => :check_units_type
  # def check_units_type
  #   check_ws_absence(self.units_type, "units_type")
  # end
  # 
  # validates_with_method :units_abbreviation, :method => :check_units_abbreviation
  # def check_units_abbreviation
  #   check_ws_absence(self.units_abbreviation, "units_abbreviation")
  # end
end