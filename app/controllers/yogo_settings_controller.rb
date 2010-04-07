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
  
  ##
  # displays settings index page
  #
  # @example http://localhost:3000/yogo_settings
  #
  # @return displays settings index page
  #
  # @author Yogo Team
  #
  # @api public
  def index
    
  end
  
  ##
  # this shows yogo setting
  #
  # @example http://localhost:3000/yogo_settings
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return displays setting
  #
  # @author Yogo Team
  #
  # @api public
  def show
    @key = params[:id]
    @value = Yogo::Settings[@key]
    
    respond_to do |format|
      format.html
    end
  end
  ##
  # displays an edit page
  #
  # @example http://localhost:3000/yogo_settings/edit/1
  #  edits setting 1
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return displays edit page
  #
  # @author Yogo Team
  #
  # @api public
  def edit
    @key = params[:id]
    @value = Yogo::Settings[@key]
    
    respond_to do |format|
      format.html
    end
  end
  ##
  # updates settings
  #
  # @example http://localhost:3000/yogo_settings/update
  #
  # @param [Hash] params
  # @option params [String] :id
  #
  # @return if save was sucessful redirect to settings index 
  #   else redirects to edit
  #
  # @author Yogo Team
  #
  # @api public
  def update
    
  end
  
end