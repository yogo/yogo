# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: datamapper.rb
#

# Require custom extensions to datamapper.
# require 'datamapper/model'
require 'datamapper/search'
require 'datamapper/dm-userstamp'
require 'datamapper/property/yogo_file'
require 'datamapper/property/yogo_image'
require 'datamapper/property/raw'

# When saving models don't be terse
DataMapper::Model.raise_on_save_failure = true

# Read the configuration from the existing database.yml file
# config = Rails.configuration.database_configuration

# Load the project model and migrate it if needed.
Project
Setting
User
Role
Membership
# Site
Unit
# Variable
FieldMethod
VariableNameCV
SampleMediumCV
ValueTypeCV
SpeciationCV
DataTypeCV
GeneralCategoryCV
SampleTypeCV
SampleMaterial
LabMethod


DataMapper.finalize

DataMapper::Model.descendants.each do |model|
  begin
    model::Version
  rescue
  end
end

