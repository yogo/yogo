# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and
# offsets.  This is a controlled vocabulary table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class Voeis::Unit < Yogo::Collection::Data

  def update_model
  end

  def generate_model
    DataMapper::Model.new do
      property :id, Serial, :required => true, :key =>true
      property :units_name, String, :required => true
      property :units_type, String, :required => true
      property :units_abbreviation, String, :required => true

      has n, :data_stream_columns, :model=>"DataStreamColumn", :through =>Resource
      has n, :variables, :model =>"Variable", :through => Resource
    end
  end
end