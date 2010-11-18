# class Variable
#   include DataMapper::Resource
# 
#   property :id,                Serial
#   property :his_id,            Integer, :required => false
#   property :variable_code,     String, :required => true, :length => 512
#   property :variable_name,     String, :required => true, :length => 512
#   property :speciation,        String, :required => true, :default => 'Not Applicable', :length => 512
#   property :variable_units_id, Integer, :required => true
#   property :sample_medium,     String, :required => true, :default => 'Unknown', :length => 512
#   property :value_type,        String, :required => true, :default =>'Unknown', :length => 512
#   property :is_regular,        Boolean, :required => true, :default => false
#   property :time_support,      Float, :required => true
#   property :time_units_id,     Integer, :required => true, :default => 103
#   property :data_type,         String, :required => true, :default => 'Unknown', :length => 512
#   property :general_category,  String, :required => true, :default => 'Unknown', :length => 512
#   property :no_data_value,     Float, :required => true, :default => -9999
#   property :updated_at,        DateTime, :required => true,  :default => DateTime.now
# 
#   is_versioned :on => :updated_at
#   
#   before(:save) {
#     self.updated_at = DateTime.now
#   }
# 
#   has n, :units, :model => "Unit", :through => Resource
# 
#   def self.load_from_his
#     his_variables = His::Variable.all
# 
#     his_variables.each do |his_v|
#       if self.first(:his_id => his_v.id).nil?
#         self.create(:his_id => his_v.id,
#                     :variable_name => his_v.variable_name,
#                     :variable_code => his_v.variable_code,
#                     :speciation => his_v.speciation,
#                     :variable_units_id => his_v.variable_units_id,
#                     :sample_medium => his_v.sample_medium,
#                     :value_type => his_v.value_type,
#                     :is_regular => his_v.is_regular,
#                     :time_support => his_v.time_support,
#                     :time_units_id => his_v.time_units_id,
#                     :data_type => his_v.data_type,
#                     :general_category => his_v.general_category,
#                     :no_data_value => his_v.no_data_value)
#       end
#     end
#   end
# 
#   def store_to_his(u_id)
#     var_to_store = self.first(:id => u_id)
#     if var_to_store.is_regular == true
#       reg = 1
#     else
#       reg =0
#     end
#     new_his_var = His::Variable.new(:variable_name => var_to_store.variable_name,
#                                         :variable_code => var_to_store.variable_code,
#                                         :speciation => var_to_store.speciation,
#                                         :variable_units_id => var_to_store.variable_units_id,
#                                         :sample_medium => var_to_store.sample_medium,
#                                         :value_type => var_to_store.value_type,
#                                         :is_regular => reg,
#                                         :time_support => var_to_store.time_support,
#                                         :time_units_id => var_to_store.time_units_id,
#                                         :data_type => var_to_store.data_type,
#                                         :general_category => var_to_store.general_category,
#                                         :no_data_value => var_to_store.no_data_value)
#     new_his_var.save
#     puts new_his_var.errors.inspect
#     var_to_store.his_id = new_his_var.id
#     var_to_store.save
#     new_his_var
#   end
# end