# SampleMediumCV
#
# This is a "Varialble"
# The SampleMediumCV table contains the controlled vocabulary for sample media.
# This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
# requested at http://water.usu.edu/cuahsi/odm/.
#
class Voeis::SampleMediumCV
  include DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,         Serial
  property :term,       String, :required => true, :index => true
  property :definition, Text

  yogo_versioned
  
  def self.load_from_his
    his_sample_mediums = His::SampleMediumCV.all

    his_sample_mediums.each do |his_sm|
        self.first_or_create(
                    :term => his_sm.term,
                    :definition=> his_sm.definition)
    end
  end

  def store_to_his(u_id)
    var_to_store = self.first(:id => u_id)
    if var_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_samp_med = His::SampleMediumCV.new(:term => var_to_store.term,
                                        :definition => var_to_store.definition)
    new_his_samp_med.save
    puts new_his_samp_med.errors.inspect
    var_to_store.his_id = new_his_samp_med.id
    var_to_store.save
    new_his_samp_med
  end
end
