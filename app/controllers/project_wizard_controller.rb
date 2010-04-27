# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# @todo Describe Me
class ProjectWizardController < ApplicationController
  
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
  #   get /project_wizard/import_csv 
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
  def manage
    
  end
  
end