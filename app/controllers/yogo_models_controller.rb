# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# Functionality for CRUD of yogo project models
# 
class YogoModelsController < ApplicationController
  before_filter :find_parent_items
  
  # Constant for the supported Human readable datatypes
  Human_types = { "Decimal"        => BigDecimal, 
                  "Integer"        => Integer,
                  "Text"           => String, 
                  "True/False"     => DataMapper::Types::Boolean, 
                  "Date"           => DateTime }
  
  # Provides a list of the models for the current project
  # 
  def index
    @models = @project.models
  end
  
  # Display a model schema with Human readable datatypes
  #
  def show
    @model = @project.get_model(params[:id])
    @types = Human_types.invert
  end
  
  # Allows a user to add a field/property to an existing model
  #
  def edit
    @model = @project.get_model(params[:id])
    @options = Human_types.keys.collect{|key| [key,key] }
    @types = Human_types.invert
  end

  # Processes adding a field/property to an existing model
  # 
  # * models are migrated up so no data is lost
  def update
    @model = @project.get_model(params[:id])
    prop_name = params[:name].downcase
    prop_type = Human_types[params[:type]]
    #--
    # This stuff need to be pushed down into the model. In due time.
    #++
    
    # Type Checking
    if !prop_type.nil? &&
        !prop_name.blank? &&
          @model.send(:property, prop_name.to_sym, prop_type, :required => false)
      @model.auto_migrate_up!
      flash[:notice] = "Property #{prop_name} added"
      redirect_to project_yogo_model_url(@project, @model.name.split("::")[-1])
    else
      flash[:notice] = "Property NOT added."
      redirect_to edit_project_yogo_model_url(@project, @model.name.split("::")[-1])
    end

  end  
  
  # Removes a model from the project (including data)
  # 
  # * The table and data associated with this model will be removed from the repo
  def destroy
    model = @project.get_model(params[:id])
    @project.delete_model(model)
    redirect_to project_yogo_models_url(@project)
  end
  
  private
  
  # Sets @project to the current project_id parameter
  #
  def find_parent_items
    @project = Project.get(params[:project_id])
  end
end