# DataTypeCV
#
# The DataType CV table contains the controlled vocabulary for the DataType field in
# the Variable model
#
class DataTypeCV
  include DataMapper::Resource
  
  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, Text
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  has n,   :variables, :model => "Variable", :through => Resource
  
  
  def self.load_from_his
    his_data_types = His::DataTypeCV.all

    his_data_types.each do |his_dt|
        self.first_or_create(
                    :term => his_dt.term,
                    :definition=> his_dt.definition)
      
    end
  end

  def store_to_his(u_id)
    data_type_to_store = self.first(:id => u_id)
    if data_type_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_data_type = His::DataTypeCV.new(:term => data_type_to_store.term,
                                        :definition => data_type_to_store.definition)
    new_his_data_type.save
    puts new_his_data_type.errors.inspect
    data_type_to_store.his_id = new_his_data_type.id
    data_type_to_store.save
    new_his_data_type
  end
end
