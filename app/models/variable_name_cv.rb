# VariableNameCV
#
# The VariableName CV table contains the controlled vocabulary for the VariableName field in
# the Variable model
#
class VariableNameCV
  include DataMapper::Resource
  
  property :his_id, Integer, :required => false
  property :term,       String, :required => true, :key => true, :format => /[^\t|\n|\r]/
  property :definition, String
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }
  has n,   :variables, :model => "Variable", :through => Resource
  
  
  def self.load_from_his
    his_variable_names = His::VariableNameCV.all

    his_variable_names.each do |his_v|
      if self.first(:his_id => his_v.id).nil?
        self.create(:his_id => his_v.id,
                    :term => his_v.term,
                    :definition=> his_v.definition)
      end
    end
  end

  def store_to_his(u_id)
    var_to_store = self.first(:id => u_id)
    if var_to_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_var_name = His::VariableNameCV.new(:term => var_to_store.term,
                                        :definition => var_to_store.definition)
    new_his_var_name.save
    puts new_his_var_name.errors.inspect
    var_to_store.his_id = new_his_var_name.id
    var_to_store.save
    new_his_var_name
  end
end
