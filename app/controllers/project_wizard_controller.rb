# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# @todo Describe Me
class ProjectWizardController < ApplicationController
  
  before_filter :no_headers
  # Give a project a name
  # 
  # @example
  #   get /project_wizard/name
  # 
  # This controller action is used to provide a name to a new project
  # 
  # @return [Object] nothing
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee
  # 
  # @api public
  def name
    @project = Project.new
    
    respond_to do |format|
      format.html
    end
  end

  # Give a project a name
  # 
  # @example
  #   get /project_wizard/csv_question/1
  # 
  # This controller action is used to provide a name to a new project
  # 
  # @return [Object] nothing
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee
  # 
  # @api public
  def csv_question
    @project = Project.get(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  # Put data via csv
  # 
  # @example
  #   get /project_wizard/import_csv/:id
  # 
  # This controller action is used to provide a name to a new project
  # 
  # @return [Object] nothing
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee 
  # 
  # @api public
  def import_csv
    @project = Project.get(params[:id])
    
    respond_to do |format|
      format.html
    end
  end
  
  # Put data via csv
  # 
  # @example
  #   POST /project_wizard/upload_csv/:id 
  # 
  # This controller action is used to provide a name to a new project
  # 
  # Robbie doesn't like this method.
  # 
  # @return [Object] nothing
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee 
  # 
  # @api public
  def upload_csv
    redirect_to(root_url) and return if params[:id].blank?
    
    @project = Project.get(params[:id])
    
    redirect_to(import_csv_url(@project)) and return unless request.post?

    datafile = params[:project][:datafile]
    class_name = params[:model_name]
    
    if !['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
          'application/octet-stream','application/csv'].include?(datafile.content_type)
      flash[:error] = "File type #{datafile.content_type} not allowed"
      #redirect_to project_url(@project)
    else
      # class_name = File.basename(datafile.original_filename, ".csv").singularize.camelcase
      errors = @project.process_csv(datafile.path, class_name)
      
      if errors.empty?
        flash[:notice]  = "File uploaded succesfully."
      else
        flash[:error] = errors.join("\n")
      end
      
    end
    respond_to do |format|
      if !errors.empty? || params[:submit] == 'Upload and Continue'
        format.html { render(:action => 'import_csv') }
      else
        format.html { redirect_to(project_yogo_models_url(@project)) }
      end
    end
    
    
  end
  
  # Put data via csv
  # 
  # @example
  #   get /project_wizard/csv 
  # 
  # This controller action is used to provide a name to a new project
  # 
  # @return [Object] nothing
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee
  # 
  # @api public
  def describe_dataset
    
  end
  
  private
  
  
  # Disable menu and search tab
  # 
  # This private method is used to set a view-aware variable for displaying the search-tab and menu
  # 
  # @return [TrueClass] The return value is useless
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Pol LLouuvettee
  # 
  # @api private
  def no_headers
    @no_search = true
    @no_menu = true
  end
  
end