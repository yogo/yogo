
module Yogo
  # This module contains methods for a Yogo model
  #
  # @author Robbie Lamb
  module Model

    # This method should never be called directly
    #
    # @see http://ruby-doc.org/core-1.8.7/classes/Module.html#M000402 Ruby Doc for more info
    #
    # @return [boolean]
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api private
    def self.included(base)
      base.send(:include, DataMapper::Timestamps)
      base.send(:extend,  ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:extend,  Csv)
      base.class_eval do

        validates_present :change_summary, :if => :require_change_summary?

        base.properties.each do |property|
          # Create carrierwave class for this property.
          if property.type == DataMapper::Types::YogoFile || property.type == DataMapper::Types::YogoImage
            create_uploader(property.name, property.type)
          end
        end
        
        # Original property
        # @example orginal_initialize
        # @return 
        # @api public
        class << self
          alias_method :original_property, :property
          alias_method :property, :property_with_carrierwave
        end
        
      end
    end

    # This module contains the public methods for a Yogo model
    #
    # @author Robbie Lamb
    #
    # @api public
    module ClassMethods

      # create a property in the current class
      #
      # This should never be called directly.
      #   
      # @example
      #     property :id, Serial
      #
      # @param [Model] model a Datamapper model the property is to be added to
      # @param [String or Symbol] name The name of the property to be added
      # @param [Class] type The class the property should be
      # @param [Hash] options The options hash
      #   
      # @return [Property] the property that was created. Not useful.
      # 
      # @author Yogo Team
      #
      # @see http://rdoc.info/projects/datamapper/dm-core
      # 
      # @api semipublic
      def property_with_carrierwave(name, type, options = {})
        prop = original_property(name, type, options)

        if type == DataMapper::Types::YogoFile || type == DataMapper::Types::YogoImage
          create_uploader(prop.name, prop.type)
        end
        return prop
      end

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
        properties.select{|p| p.name.to_s.match(/^yogo__/) }
      end


      # Create the asset path so we can reuse it
      # 
      # @return [String] The string path to the directory/folder to storage for assets of this model.
      # 
      # @example Get the path to the asset directory for a model
      #   Model.asset_path => "module/class"
      # 
      # @author Ivan Judson
      # 
      # @api public
      def asset_path
        self.name.gsub('::', '/')
      end

      # The name of the model humanized
      # 
      # @example 
      #   @model.public_name
      # 
      # @return [String] humanized name of the class
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api public
      def public_name
        @_public_name ||= self.name.split('::')[-1].humanize
      end
      
      # Compatability method for rails' route generation helpers
      #
      # @example
      #   @model.to_param # returns the ID as a string
      # 
      # @return [String] the object id as url param
      #
      # @author Yogo Team
      #
      # @api public
      def to_param
        self.name.demodulize
      end
      
      private
      # Creates a carrierwave uploader for the specified field
      # 
      # @example 
      #   create_uploader(:yogo__file, DataMapper::Types::YogoFile)
      # 
      # @param [Symbol or String] name the name of the property to add a handler to
      # @param [Class] type the type of property this is
      # 
      # @return [Object] nothing useful
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api private
      def create_uploader(name, type)
        path = File.join(Rails.root, Yogo::Setting['asset_directory'], asset_path)
        storage_dir = path.to_s
        anon_file_handler = Class.new(CarrierWave::Uploader::Base)
        anon_file_handler.instance_eval do 
          storage :file
          self.class_eval("def store_dir; '#{path}'; end")
        end

        # named_class = Object.class_eval("#{self.name}::#{name.to_s.camelcase}File = anon_file_handler")
        mount_uploader name, anon_file_handler
        
      end
    end

    module InstanceMethods
      
      # Compatability method for rails' route generation helpers
      #
      # @example
      #   instance.to_param # returns the ID as a string
      # 
      # @return [String] the object id as url param
      #
      # @author Yogo Team
      #
      # @api public
      def to_param
        self.yogo_id.to_s
      end
      
      private
      
      # Check to see if the change_summary field is required to be filled out
      # 
      # @return [TrueClass or FalseClass]
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api private
      def require_change_summary?
        Yogo::Setting[:require_change_sumary] && !new_record?
      end

    end

  end
end