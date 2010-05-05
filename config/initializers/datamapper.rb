# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: datamapper.rb
# 

# Require custom extensions to datamapper.
require 'datamapper/paginate'
require 'datamapper/property'
require 'datamapper/search'
require 'datamapper/paginate'
require 'datamapper/factory'
require 'datamapper/dm-userstamp'
require 'datamapper/types/yogo_file'
require 'datamapper/types/yogo_image'
require 'yogo/reflection'

# Read the configuration from the existing database.yml file
config = Rails.configuration.database_configuration

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this 
DataMapper.setup(:default, config[Rails.env])

# Alias :default to :yogo so things work well
DataMapper.setup(:yogo, config[Rails.env])

# Map the datamapper logging to rails logging
DataMapper.logger             = Rails.logger
if Object.const_defined?(:DataObjects)
  DataObjects::Postgres.logger  = Rails.logger if DataObjects.const_defined?(:Postgres)
  DataObjects::Sqlserver.logger = Rails.logger if DataObjects.const_defined?(:Sqlserver)
  DataObjects::Mysql.logger     = Rails.logger if DataObjects.const_defined?(:Mysql)
  DataObjects::Sqlite.logger    = Rails.logger if DataObjects.const_defined?(:Sqlite)
end

# Load the project model and migrate it if needed.
proj_model_file = File.join(RAILS_ROOT, "app", "models", "project.rb")
require proj_model_file

Project.auto_migrate! unless DataMapper.repository(:default).storage_exists?(Project.storage_name)