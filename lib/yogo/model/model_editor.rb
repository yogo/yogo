# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: csv.rb
#
# @author Ryan Heimbuch rheimbuch@gmail.com
module Yogo
  module Model
    # Yogo::Model::ModelEditor provides support for exporting and
    # updating Yogo Models using a simplified "Model Definition"
    # format.
    #
    # The Model Definition format presents a simplified representation
    # of a Yogo Model and its Properties. The format is intended to
    # easily converted to-from JSON and primarily serves to power
    # The Yogo Model Editor which provides end-user editing of Yogo
    # Models.
    #
    # Model Definition Format (JSON):
    #   {"guid": "model_class_name",  // not user-editable
    #    "name": "Name Display Name",  // not user-editable, but may be possible in the future
    #    "properties": [
    #       {
    #         "type": "Text",    // See Yogo::Types for the DM-Type <=> User-Type
    #         "name": "First Name",  // This will be converted to a valid prop-name and back
    #         "options": {
    #             // Optional config for properties. Currently unused.
    #         }
    #       }
    #     ]
    #   }
    module ModelEditor
      
      ##
      # Returns an approporate guid for the model
      # 
      # @example
      #   model.guid
      # 
      # @return [String]
      #  The guid for the model
      # 
      # @author Ryan Heimbuch
      # 
      # @api public
      def guid
        name.split('::').last
      end
      
      ##
      # Returns a model JSON defination for sproutcore
      # 
      # @example
      #   model.to_model_definition
      # 
      # @return [Hash]
      #   The model definition
      # 
      # @author Ryan Heimbuch
      #
      # @api public
      def to_model_definition
        model = self # This should be the actual model class
        
        model_def = {}
        model_def['guid'] = model.guid
        # model_def[:name] = model.public_name
        model_def['properties'] = []

        properties = model.usable_properties

        excluded_property_options = DataMapper::Property::OPTIONS.dup
        excluded_property_options << :separator << :prefix << :position

        properties.each_with_index do |prop, index|
          prop_options = prop.options.dup.symbolize_keys
          prop_position = prop_options[:position] || index

          prop_options.reject!{|k,v| excluded_property_options.include?(k) }

          prop_type = Yogo::Types.dm_to_human(prop.type)
          prop_name = prop.display_name.to_s.titleize

          prop_def = {
            'childRecordKey' => "#{model.guid}.#{prop.name}", #for sproutcore
            'type' => prop_type,
            'name' => prop_name,
            'options' => prop_options.dup
          }
          
          puts prop_def.inspect

          prop_position_offset = model_def['properties'][prop_position] ? properties.size : 0
          model_def['properties'][prop_position+prop_position_offset] = prop_def
        end

        return model_def
      end
      
      ##
      # Updates the model definition from a hash
      # 
      # @example
      #   model.update_model_definition(definition)
      # 
      # @param [Hash] definition
      #   The updated model definition as a hash
      #   
      # @return [Model]
      #   Not useful
      # 
      # @author Ryan Heimbuch
      #
      # @api public
      def update_model_definition(definition)
        model = self # this should be the actual model class
        definition = definition.dup.symbolize_keys!
        definition_id = definition[:guid] || model.guid

        (model.guid == definition_id) || raise("model definition for #{definition_id} cannot be applied to #{model.guid}")
        
        
        # We're going to be evil and REMOVE all the user-defined properties from the model
        user_props = model.usable_properties.dup
        hidden_props = model.properties.reject{|p| user_props.include? p}

        model.instance_variable_get(:@properties).each_value do |prop_set|
          prop_set.instance_variable_get(:@properties).clear
          prop_set.clear
          hidden_props.each {|hp| prop_set << hp}
        end

        # logger.debug { model.usable_properties.map{|p| p.name}.inspect }
        #         logger.debug { model.properties.map{|p| p.name}.inspect }

        property_definitions = definition[:properties]
        # These options are fixed and should be merged into every property
        default_property_options = {:required => false, 
                                    :separator => '__', 
                                    :prefix => 'yogo'}
        property_definitions.each_with_index do |prop_def, index|
          prop_def = prop_def.dup.symbolize_keys!
          def_type = prop_def[:type].to_s
          def_name = prop_def[:name].to_s
          next if def_type.empty? || def_name.empty?
          
          property_type = Yogo::Types.human_to_dm(def_type)
          property_name = def_name.squish.downcase.gsub(' ', '_').to_sym
          property_options = {}.reverse_merge(default_property_options).reverse_merge(prop_def[:options] || {})
          property_options[:position] = index
          property_options = property_options.symbolize_keys
          # logger.debug { "model.send(:property, #{property_name.inspect}, #{property_type.inspect}, #{property_options.inspect})"}
          model.send(:property, property_name, property_type, property_options)

        end
        # Type Mapping: prop_type = Yogo::Types.human_to_dm(model_def_type_name)

        # update model props: model.send(:property, :prop_name.to_sym, prop_type, :required => false, :position => prop[2], :separator => '__', :prefix => 'yogo')
        begin
          model.auto_upgrade!
          model.backup_schema!
        rescue ArgumentError => e
          Rails.logger.warn("Schema Backup Failed!")
          Rails.logger.error(e)
        end

        return model
      end
    end
  end
end