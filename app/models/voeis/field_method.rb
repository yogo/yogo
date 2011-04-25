# -*- coding: utf-8 -*-
# Methods
#
# This is a "Data Collection Methods
# The Methods table lists the methods used to collect the data and any additional information about
# the method.
# The following rules and best practices should be used when populating this table:
# * The MethodID field is the primary key, must be a unique integer, and cannot be NULL.
# * There is no default value for the MethodDescription field in this table.  Rather, this table
# should contain a record with MethodID = 0, MethodDescription = “Unknown”, and
# MethodLink = NULL.  A MethodID of 0 should be used as the MethodID for any data
# values for which the method used to create the value is unknown (i.e., the default value
# for the MethodID field in the DataValues table is 0).
# * Methods should describe the manner in which the observation was collected (i.e.,
# collected manually, or collected using an automated sampler) or measured (i.e., measured
# using a temperature sensor or measured using a turbidity sensor).  Details about the
# specific sensor models and manufacturers can be included in the MethodDescription.
#
class Voeis::FieldMethod
  include DataMapper::Resource
  include Yogo::Versioned::DataMapper::Resource

  property :id,                 Serial
  property :method_description, Text,   :required => true
  property :method_link,        Text,   :required => false
  
  yogo_versioned

  property :his_id, Integer
  
  def self.load_from_his
    his_field_methods = His::FieldMethod.all

    his_field_methods.each do |his_fm|
      if self.first(:his_id => his_fm.id).nil?
        self.create(:his_id => his_fm.id,
                    :method_description=> his_fm.method_description,
                    :method_link=> his_fm.method_link)
      end
    end
  end

  def store_to_his(u_id)
    field_methodto_store = self.first(:id => u_id)
    if field_methodto_store.is_regular == true
      reg = 1
    else
      reg =0
    end
    new_his_field_method = His::FieldMethod.new(:method_description => field_methodto_store.method_description,
                                        :method_link=> field_methodto_store.method_link)
    new_his_field_method.save
    puts new_his_field_method.errors.inspect
    field_methodto_store.his_id = new_his_field_method.id
    field_methodto_store.save
    new_his_field_method
  end
end
