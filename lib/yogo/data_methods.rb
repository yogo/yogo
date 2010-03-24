# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: data_methods.rb
# 
module Yogo
  module DataMethods
    @@reserved_names = ["id", "iD", "Id", "ID"]
    # FIXME @return []
    # FIXME @api private, semipublic, or public
    def self.included(base)
      base.send(:extend, ClassMethods)
      base.class_eval do

        base.properties.each do |property|
          # Create carrierwave class for this property.
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

          elsif property.type == DataMapper::Types::YogoImage
            path = Rails.root / 'public' / 'images' 
            self.name.split('::').each{ |mod| path = path / mod }
            storage_dir = path.to_s
            anon_file_handler = Class.new(CarrierWave::Uploader::Base)
            anon_file_handler.instance_eval do 
              storage :file
              self.class_eval("def store_dir; '#{path}'; end")
            end

            named_class = Object.class_eval("#{self.name}::#{property.name.to_s.camelcase}File = anon_file_handler")
            mount_uploader property.name, named_class

          end
        end
      end
    end

    # @return [String] makes "yogo___" for variable name
    # FIXME @api private, semipublic, or public
    def self.map_attribute(name)
      # @@reserved_names.include?(name) ? "yogo___"+name : name
      name
    end

    module ClassMethods
      # The properties on a model for human consumption.
      # 
      # @example @model.usable_properties.each{|prop| puts prop.display_name }
      # 
      # @return [Array] properties that are usable by human consumption
      # 
      # @api public
      def usable_properties
        properties.select{|p| p.name != :yogo_id }
      end
    end
  end
end
