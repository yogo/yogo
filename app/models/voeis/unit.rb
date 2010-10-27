# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and
# offsets.  This is a controlled vocabulary table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
#
class Voeis::Unit
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :units_name, String, :required => true, :length => 512
  property :units_type, String, :required => true, :length => 512
  property :units_abbreviation, String, :required => true
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :data_stream_columns,  :model => "Voeis::DataStreamColumn", :through =>Resource
  has n, :variables,            :model => "Voeis::Variable", :through => Resource
end