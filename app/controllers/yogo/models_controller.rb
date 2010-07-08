# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_models_controller.rb
# Functionality for CRUD of yogo project models
# 
class Yogo::ModelsController < ApplicationController
  before_filter :find_parent_items, :check_project_authorization
  
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
      format.html
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
    model_def = HashWithIndifferentAccess.new(params['Model'])
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
    logger.debug(model_def.inspect)
    @model.auto_migrate!
    @model.update_model_definition(model_def)
    
    respond_to do |format|
      format.html { redirect_to(project_yogo_model_url(@project, @model)) }
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
    # redirect_to project_url(@project)
    respond_to do |request|
      request.html { redirect_to project_url(@project) }
      request.json { head :ok }
    end
  end
  
  private
  
  ##
  # pulls model data into a CSV file format
  #
  # @return [File] Allows download of yogo project model data in CSV format
  #
  # @author Yogo Team
  #
  # @api private
  def download_csv
    send_data(@model.to_yogo_csv,
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
  
  ##
  # Checks to see if the current user is authorized to perform the current action
  # @return [nil]
  # @raise Execption
  # @author lamb
  # @api private
  def check_project_authorization
    if !Yogo::Setting[:local_only]
      raise AuthenticationError if !@project.is_public? && !logged_in?
        action = request.parameters["action"]
        if ['index', 'show', 'download_csv'].include?(action)
          raise AuthorizationError unless @project.is_public? || (logged_in? && current_user.is_in_project?(@project))
        else
          raise AuthenticationError if !logged_in?
          raise AuthorizationError  if !current_user.has_permission?(:edit_model_descriptions,@project)
        end
    end
  end
end