# Units
#
# The Units table gives the Units and UnitsType associated with variables, time support, and
# offsets.  This is a controlled vocabulary table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
#
class Unit
  include DataMapper::Resource

  property :id, Serial
  property :his_id, Integer, :required => false
  property :units_name, String, :required => true, :length => 512
  property :units_type, String, :required => true, :length => 512
  property :units_abbreviation, String, :required => true

  has n, :variables, :model => "Variable", :through => Resource


  def self.load_from_his
    his_units = His::Unit.all
    his_units.each do |his_u|
      if self.first(:his_id => his_u.id).nil?
        self.create(:his_id => his_u.id,
                    :units_name => his_u.units_name,
                    :units_type => his_u.units_type,
                    :units_abbreviation => his_u.units_abbreviation)
      end
    end
  end

  #probably don't want to do it this way
  #probably want to use self but my brain is blanking
  #so I'm writing it this way for now in the name of speed
  def self.store_to_his(u_id)
    unit_to_store = self.first(:id => u_id)
    new_his_unit = His::Units.create(:units_name => unit_to_store.units_name,
                                     :units_type => unit_to_store.units_type,
                                     :units_abbreviation => unit_to_store.units_abbreviation)
    unit_to_store.his_id = new_his_unit.id
    unit_to_store.save
  end
end
