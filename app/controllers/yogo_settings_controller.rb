# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# Functionality for CRUD of data within a yogo project's model
# Additionally upload and download of data via CSV is provided
#
class YogoSettingsController < ApplicationController
  
  
  def index
    
  end
  
  def show
    @key = params[:id]
    @value = Yogo::Settings[@key]
    
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @key = params[:id]
    @value = Yogo::Settings[@key]
    
    respond_to do |format|
      format.html
    end
  end
  
  def update
    
  end
  
end