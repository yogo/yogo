# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: yogo_data_controller.rb
# Functionality for CRUD of data within a yogo project's model
# Additionally upload and download of data via CSV is provided
#
class SettingsController < InheritedResources::Base

  protected

  def collection
    @settings ||= resource_class.all
  end

  def resource
    @setting ||= resource_class.get(params[:id])
  end
end