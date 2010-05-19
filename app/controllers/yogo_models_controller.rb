# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_models_controller.rb
# Functionality for CRUD of yogo project models
# 
class YogoModelsController < ApplicationController
  before_filter :find_parent_items
  
  ##
  # Provides a list of the models for the current project
  #
  # @example http://localhost:3000/yogo_model
  #
  # @return Displays list of all the models for the project
  #
  # @author Yogo Team
  #
  # @api public
  def index
    @models = @project.models
    @no_search = true
    
    respond_to do |format|
      format.html
      format.json { render( :json => {"models" => @models.map{|m| m.to_model_definition },
                                      "count" => @models.size } )}
    end
  end
  
  ##
  # Display a model schema with Human readable datatypes
  #
  # @example http://localhost:3000/yogo_model/1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return [Model] Displays a yogo project model
  #
  # @author Yogo Team
  #
  # @api public
  def show
    @model = @project.get_model(params[:id])
    
    respond_to do |format|
      # format.html
      format.json do
        
        render( :json => { "Model" => @model.to_model_definition } )
      end
      format.csv { download_csv }
    end

  end
  
  ##
  # Creates a new model object
  #
  # @example http://localhost:3000/yogo_model/new
  #
  # @return [Object] returns an empty model
  #
  # @author Yogo Team
  #
  # @api public
  def new
    @model = Class.new
    
    @options = Yogo::Types.human_types.map{|key| [key,key] }
  end
  
  # creates new model
  #
  # @example http://localhost:3000/yogo_model/create
  #
  # @param [Hash] params
  # @option params [String] :class_name
  # @option params [Hash] :new_property it has name, type, and position keys
  #
  # @return redirects to show model page if save was sucessful 
  #   else redirects to new
  #
  # @author Yogo Team
  #
  # @api public
  def create
    model_def = params['Model'].symbolize_keys
    @model = nil
    class_name = nil
    
    if model_def[:guid]
      class_name = model_def[:guid]
    else
      raise "Cannot create a Model without a name or id"
    end
    
    @model = @project.add_model(class_name, {})
    logger.debug(class_name)
    logger.debug(@model.guid)
    @model.auto_migrate!
    @model.update_model_definition(model_def)
    
    respond_to do |format|
      format.html { redirect_to(project_yogo_model_url(@project, @model.name.demodulize)) }
      format.json do
        render( :json => { "Model" => @model.to_model_definition } )
      end
    end
    
  end

  # Allows a user to add a field/property to an existing model
  #
  # @example http://localhost:3000/yogo_model/edit/1
  #  edits data model 1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return [Model] Allows a user to edit a yogo project model attributes
  #
  # @author Yogo Team
  #
  # @api public
  def edit
    @model = @project.get_model(params[:id])
    @options = Yogo::Types.human_types.map{|key| [key,key] } 
  end

  # Processes adding a field/property to an existing model
  # 
  # models are migrated up so no data is lost
  #  
  # @example http://localhost:3000/yogo_model/update
  #
  # @param [Hash] params
  # @option params [String] :id
  # @option params [Hash] :new_property it has name, type, and position keys
  # @option params [Hash] :property it has name, type, and position keys
  #
  # @return [Model] Updates a model
  #
  # @author Yogo Team
  #
  # @api public
  def update
    model = @project.get_model(params[:id])
    model_def = params['Model']
    logger.debug { model_def.inspect }
    
    #update_model_with_definition(model_def, model)
    model.update_model_definition(model_def)
    
    updated_model_def = model.to_model_definition
    logger.debug { model }
    logger.debug { model.properties.map {|p| [p.name, p.type, p.display_name] }.inspect }
    logger.debug { updated_model_def.inspect }
    respond_to do |format|
      # format.html
      format.json do
        render( :json => { "Model" => updated_model_def } )
      end
    end
  end
  
  ##
  # Removes a model from the project (including data)
  #
  # the table and data associated with this model will be removed from the repo
  #
  # @example http://localhost:3000/yogo_model/destroy/1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return redirects to model index
  #
  # @author Yogo Team
  #
  # @api public
  def destroy
    model = @project.get_model(params[:id])
    @project.delete_model(model)
    redirect_to project_url(@project)
  end
  
  ##
  # List attributes for a model
  #
  # @example http://localhost:3000/yogo_model/1/list_attributes
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return renders list of the attributes
  #
  # @author Yogo Team
  #
  # @api public
  def list_attributes
    @model = @project.get_model(params[:id])
    @attributes = Yogo::Navigation.attributes(@model)
    
    respond_to do |wants|
      wants.html 
      wants.js { render(:partial => 'list_attributes', :locals => { :model => @model, :attributes => @attributes, :project => @project })}
    end
  end
  
  ##
  # Reloads the models from our special backup Hopefully temporary
  # 
  # @example
  #   post /yogo_model/1/refresh_attributes
  # 
  # @return redirects to originating page
  # 
  # @author lamb
  # @api public
  def refresh_attributes
    @project.reload_schemas_from_backup!
    
    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end
  
  private
  
  ##
  # converts the yogo model into the format used by the sproutcore model editor
  #
  # @return [String]
  #  The model definition in JSON
  # 
  # @api private
  # def model_definition_for(model)
  #   model_def = {}
  #   model_def[:name] = model.name.split('::').last.gsub('_', ' ')
  #   model_def[:properties] = []
  #   
  #   properties = model.usable_properties
  #   
  #   excluded_property_options = DataMapper::Property::OPTIONS.dup
  #   excluded_property_options << :separator << :prefix << :position
  #   
  #   properties.each_with_index do |prop, index|
  #     prop_options = prop.options.dup.symbolize_keys
  #     prop_position = prop_options[:position] || index
  #     
  #     prop_options.reject!{|k,v| excluded_property_options.include?(k) }
  #     
  #     prop_type = Yogo::Types.dm_to_human(prop.type)
  #     prop_name = prop.display_name.to_s.titleize
  #     
  #     prop_def = {
  #       :type => prop_type,
  #       :name => prop_name,
  #       :options => prop_options.dup
  #     }
  #     
  #     prop_position_offset = model_def[:properties][prop_position] ? properties.size : 0
  #     model_def[:properties][prop_position+prop_position_offset] = prop_def
  #   end
  #   
  #   return model_def
  # end
  
  ##
  # Updates the yogo model to match the new model definition
  # 
  # @return [Object] 
  #   the updated model
  # 
  # @api private
  # def update_model_with_definition(definition, model)
  #    definition_name = definition[:name] || raise("model definition must have a 'name' property")
  #    model_name = model.name.split('::').last.gsub('_', ' ')
  #    
  #    (model_name == definition_name) || raise("model definition for #{definition_name} cannot be applied to #{model.name}")
  #    
  #    # We're going to be evil and REMOVE all the user-defined properties from the model
  #    user_props = model.usable_properties.dup
  #    hidden_props = model.properties.reject{|p| user_props.include? p}
  #    
  #    model.instance_variable_get(:@properties).each_value do |prop_set|
  #      prop_set.instance_variable_get(:@properties).clear
  #      prop_set.clear
  #      hidden_props.each {|hp| prop_set << hp}
  #    end
  #    
  #    logger.debug { model.usable_properties.map{|p| p.name}.inspect }
  #    logger.debug { model.properties.map{|p| p.name}.inspect }
  #    
  #    property_definitions = definition[:properties]
  #    # These options are fixed and should be merged into every property
  #    default_property_options = {:required => false, 
  #                                :separator => '__', 
  #                                :prefix => 'yogo'}
  #    property_definitions.each_with_index do |prop_def, index|
  #      def_type = prop_def[:type].to_s
  #      def_name = prop_def[:name].to_s
  #      next if def_type.empty? || def_name.empty?
  #      
  #      prop_def = prop_def.dup.symbolize_keys!
  #      property_type = Yogo::Types.human_to_dm(def_type)
  #      property_name = def_name.squish.downcase.gsub(' ', '_').to_sym
  #      property_options = {}.reverse_merge(default_property_options).reverse_merge(prop_def[:options] || {})
  #      property_options[:position] = index
  #      property_options = property_options.symbolize_keys
  #      logger.debug { "model.send(:property, #{property_name.inspect}, #{property_type.inspect}, #{property_options.inspect})"}
  #      model.send(:property, property_name, property_type, property_options)
  #      
  #    end
  #    # Type Mapping: prop_type = Yogo::Types.human_to_dm(model_def_type_name)
  #    
  #    # update model props: model.send(:property, :prop_name.to_sym, prop_type, :required => false, :position => prop[2], :separator => '__', :prefix => 'yogo')
  #    model.auto_upgrade!
  #    model.backup_schema!
  #    return model
  #  end
  
  ##
  # pulls model data into a CSV file format
  #
  # @return [File] Allows download of yogo project model data in CSV format
  #
  # @author Yogo Team
  #
  # @api private
  def download_csv
    send_data(@model.make_csv(false),
              :filename    => "#{@model.name.demodulize.tableize.singular}.csv", 
              :type        => "text/csv", 
              :disposition => 'attachment')
  end
  
  ##
  # returns a project
  #
  # @param [Hash] params
  # @option params [String] :project_id
  #
  # @return [Model] returns a project
  #
  # @author Yogo Team
  #
  # @api private
  def find_parent_items
    @project = Project.get(params[:project_id])
  end
  
  ##
  # validates model name or column name
  #
  # @param [String] potential name
  #
  # @return [Boolean] returns true or false
  #
  # @author Yogo Team
  #
  # @api private
  def valid_model_or_column_name?(potential_name)
    # TODO: Validations should not be here.
    !potential_name.match(/^\d|\.|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\-/)
  end
end