 # SampleTypeCV
 #
 # This is a "Data Collection Methods"
 # The SampleMediumCV table contains the controlled vocabulary for sample media.
 # This table is pre-populated within the ODM.  Changes to this controlled vocabulary can be
 # requested at http://water.usu.edu/cuahsi/odm/.
 #
 class SampleTypeCV
   include DataMapper::Resource
   
   property :his_id, Integer, :required => false
   property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
   property :definition, Text
   property :updated_at, DateTime, :required => true,  :default => DateTime.now

   is_versioned :on => :updated_at

   before(:save) {
     self.updated_at = DateTime.now
   }
   has n,   :variables, :model => "Variable", :through => Resource


   def self.load_from_his
     his_sample_types = His::SampleTypeCV.all

     his_sample_types.each do |his_st|
       if self.first(:his_id => his_st.id).nil?
         self.create(:his_id => his_st.id,
                     :term => his_st.term,
                     :definition=> his_st.definition)
       end
     end
   end

   def store_to_his(u_id)
     samp_to_store = self.first(:id => u_id)
     if samp_to_store.is_regular == true
       reg = 1
     else
       reg =0
     end
     new_his_samp_type = His::SampleTypeCV.new(:term => samp_to_store.term,
                                         :definition => samp_to_store.definition)
     new_his_samp_type.save
     puts new_his_samp_type.errors.inspect
     samp_to_store.his_id = new_his_samp_type.id
     samp_to_store.save
     new_his_samp_type
   end
 end
