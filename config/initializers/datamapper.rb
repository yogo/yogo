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
#Project
# Setting
# User
# Role
# Membership
# Site
# Unit
# Variable
# FieldMethod
# VariableNameCV
# SampleMediumCV
# ValueTypeCV
# SpeciationCV
# DataTypeCV
# GeneralCategoryCV
# SampleTypeCV
# SampleMaterial
# LabMethod

# DataMapper.finalize
# DataMapper.auto_migrate! unless DataMapper.repository(:default).storage_exists?(Project.storage_name) &&
# DataMapper.repository(:default).storage_exists?(Setting.storage_name) &&
# DataMapper.repository(:default).storage_exists?(User.storage_name) &&
# DataMapper.repository(:default).storage_exists?(Role.storage_name) &&
# DataMapper.repository(:default).storage_exists?(Membership.storage_name) &&
# DataMapper.repository(:default).storage_exists?(Site.storage_name) &&
# DataMapper.repository(:default).storage_exists?(Unit.storage_name) &&                         DataMapper.repository(:default).storage_exists?(Variable.storage_name) &&
# DataMapper.repository(:default).storage_exists?(FieldMethod.storage_name) &&                      DataMapper.repository(:default).storage_exists?(VariableNameCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(SampleMediumCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(ValueTypeCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(SpeciationCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(DataTypeCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(GeneralCategoryCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(SampleTypeCV.storage_name) &&
# DataMapper.repository(:default).storage_exists?(SampleMaterial.storage_name) &&
# DataMapper.repository(:default).storage_exists?(LabMethod.storage_name)