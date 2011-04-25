# ValueTypeCV
#
# The ValueTypeCV table contains the controlled vocabulary for the ValueType field in the
# Variables and SeriesCatalog tables.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
#
class Voeis::ValueTypeCV
  include DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,         Serial
  property :term,       String, :required => true, :index => true, :format => /[^\t|\n|\r]/
  property :definition, Text
  
  yogo_versioned

  has n, :variables, :model => "Voeis::Variable", :through => Resource  
  
  def self.load_from_his
    his_value_types = His::ValueTypeCV.all

    his_value_types.each do |his_vt|
        self.first_or_create(
                    :term => his_vt.term,
                    :definition=> his_vt.definition)
      
    end
  end

  def store_to_his(u_id)
    val_type_to_store = self.first(:id => u_id)
    if val_type_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_val_type = His::ValueTypeCV.new(:term => val_type_to_store.term,
                                        :definition => val_type_to_store.definition)
    new_his_val_type.save
    puts new_his_val_type.errors.inspect
    val_type_to_store.his_id = new_his_val_type.id
    val_type_to_store.save
    new_his_val_type
  end
  
end
