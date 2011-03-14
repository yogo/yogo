# SpeciatonCV
#
# The SpeciationCV table contains the controlled vocabulary for the Speciation field in the
# Variables table.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class Voeis::SpeciationCV
  include DataMapper::Resource

  property :id,         Serial
  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, Text
  
  timestamps :at
  
  is_versioned :on => :updated_at

  has n, :variables, :model => "Voeis::Variable", :through => Resource
  
  def self.load_from_his
    his_speciations = His::SpeciationCV.all

    his_speciations.each do |his_sp|

        self.first_or_create(
                    :term => his_sp.term,
                    :definition=> his_sp.definition)
      
    end
  end

  def store_to_his(u_id)
    speciation_to_store = self.first(:id => u_id)
    if speciation_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_speciation = His::SpeciationCV.new(:term => speciation_to_store.term,
                                        :definition => speciation_to_store.definition)
    new_his_speciation.save
    puts new_his_speciation.errors.inspect
    speciation_to_store.his_id = new_his_speciation.id
    speciation_to_store.save
    new_his_speciation
  end
end
