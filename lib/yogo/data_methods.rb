# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: data_methods.rb
# 
module Yogo
  module DataMethods
    def self.included(base)
      base.class_eval do
        # extend  ClassMethods
        # include InstanceMethods

        base.properties.each do |property|
          if property.type == DataMapper::Types::YogoFile
            path = Rails.root / 'public' / 'files' 
            self.name.split('::').each{ |mod| path = path / mod }
            storage_dir = path.to_s
            anon_file_handler = Class.new(CarrierWave::Uploader::Base)
            anon_file_handler.instance_eval do 
              storage :file
              
              self.class_eval("def store_dir; '#{path}'; end")
              
            end
            
            named_class = Object.class_eval("#{self.name}::#{property.name.to_s.camelcase}File = anon_file_handler")
            mount_uploader property.name, named_class
            
            # method = %{
            #   def #{property.name}=(new_file)
            #     raise ArgumentError.new("Expected a Tempfile but recieved a \#{new_file.class}") unless new_file.is_a?(Tempfile)
            #     saved_path = store_file(new_file)
            #     # new_file.content_type
            #     attribute_set(:#{property.name}, saved_path)
            #   end
            # }
            # base.send(:eval, method)
          end
        end
      end
    end
    
    # module InstanceMethods
    #   
    #   def store_file(temp_file)
    #     path = Rails.root / 'public' / 'files' 
    #     self.class.name.split('::').each{ |mod| path = path / mod }
    #     mkdir_p(path)
    #     new_file = path / temp_file.original_filename
    #     File.open( new_file, 'w') do |file|
    #       file.binmode # for windows
    #       temp_file.binmode
    #       temp_file.each_line{ |line| file << line }
    #     end
    #     return new_file.to_s
    #   end
    #   
    # end
    # 
    # module ClassMethods
    #   
    # end
  end
end