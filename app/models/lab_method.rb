# # LabMethods
# #
# # This is a "Data Collection Methods"
# # The LabMethods table contains descriptions of the laboratory methods used to analyze physical
# # samples for specific constituents.
# # The following rules and best practices should be used when populating this table:
# # * The LabMethodID field is the primary key, must be a unique integer, and cannot be
# # NULL.  It should be implemented as an auto number/identity field.
# # * All of the fields in this table are required and cannot be null except for the
# # LabMethodLink.
# # * The default value for all of the required fields except for the LabMethodID is
# # “Unknown.”
# # * A single record should exist in this table where the LabMethodID = 0 and the LabName,
# # LabOrganization, LabMethdodName, and LabMethodDescription fields are equal to
# # “Unknown” and the LabMethodLink = NULL.  This record should be used to identify
# # samples in the Samples table for which nothing is known about the laboratory method
# # used to analyze the sample.
# #
# class LabMethod
#   include DataMapper::Resource
#   property :his_id,                 Integer
#   property :id,                     Serial
#   property :lab_name,               Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
#   property :lab_organization,       Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
#   property :lab_method_name,        Text, :required => true, :default => 'Unknown', :format => /[^\t|\n|\r]/
#   property :lab_method_description, Text, :required => true, :default => 'Unknown'
#   property :lab_method_link,        Text
#   property :updated_at, DateTime, :required => true,  :default => DateTime.now
# 
#   is_versioned :on => :updated_at
#   
#   before(:save) {
#     self.updated_at = DateTime.now
#   }
#   
#   #has n, :samples, :model => "Sample", :through => Resource
#   
#   def self.load_from_his
#     his_lab_methods = His::LabMethod.all
# 
#     his_lab_methods.each do |his_lm|
#       if self.first(:his_id => his_lm.id).nil?
#         self.create(:his_id => his_lm.id,
#                     :lab_name => his_lm.lab_name,
#                     :lab_organization=> his_lm.lab_organization,
#                     :lab_method_name => his_lm.lab_method_name,
#                     :lab_method_description => his_lm.lab_method_description,
#                     :lab_method_link => his_lm.lab_method_link)
#       end
#     end
#   end
# 
#   def store_to_his(u_id)
#     lab_methodto_store = self.first(:id => u_id)
#     if lab_methodto_store.is_regular == true
#       reg = 1
#     else
#       reg =0
#     end
#     new_his_lab_method = His::LabMethod.new(:lab_name => lab_methodto_store.lab_name,
#                                             :lab_organization=> lab_methodto_store.lab_organization,
#                                             :lab_method_name => lab_methodto_store.lab_method_name,
#                                             :lab_method_description => lab_methodto_store.lab_method_description,
#                                             :lab_method_link => lab_methodto_store.lab_method_link)
#     new_his_lab_method.save
#     puts new_his_lab_method.errors.inspect
#     lab_methodto_store.his_id = new_his_lab_method.id
#     lab_methodto_store.save
#     new_his_lab_method
#   end
# end