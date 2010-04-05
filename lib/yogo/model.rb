
module Yogo
  # This module contains methods for a Yogo model
  #
  # @author Robbie Lamb
  #
  # @api private
  module Model
      ##
      # This method should never be called directly.
      # @see http://ruby-doc.org/core-1.8.7/classes/Module.html#M000402 Ruby Doc for more info
      # @author Robbie Lamb robbie.lamb@gmail.com
      # @api private
      def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:extend, Csv)
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
      ##
      # This module contains the public methods for a Yogo model
      #
      # @author Robbie Lamb
      #
      # @api public
      module ClassMethods
        ##
        # The properties on a model for human consumption
        # 
        # @example @model.usable_properties.each{|prop| puts prop.display_name }
        # 
        # @return [Array] properties that are usable by human consumption
        # 
        # @author Robbie Lamb robbie.lamb@gmail.com
        # 
        # @api public
        def usable_properties
          properties.select{|p| p.name != :yogo_id }
        end
      end
  end
end