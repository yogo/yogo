# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: datamapper.rb
#

# Require custom extensions to datamapper.
require 'datamapper/model'
require 'datamapper/paginate'
require 'datamapper/search'
require 'datamapper/paginate'
require 'datamapper/dm-userstamp'
require 'datamapper/property/yogo_file'
require 'datamapper/property/yogo_image'
require 'datamapper/property/raw'

# Read the configuration from the existing database.yml file
config = Rails.configuration.database_configuration

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this
DataMapper.setup(:default, config[Rails.env])
DataMapper.setup(:his, config['his']) if defined?(JRUBY_VERSION)

# Use db configs in the form of "yogo_{default|persvr|sqlite|...}_{RAILS_ENV|development|production|...}"
yogo_db = ['yogo', (ENV['YOGO_DB'] || 'default'), Rails.env].join('_')
DataMapper.setup(:collection_data, config[yogo_db])

# Map the datamapper logging to rails logging
DataMapper.logger             = Rails.logger
if Object.const_defined?(:DataObjects)
  DataObjects::Postgres.logger  = Rails.logger if DataObjects.const_defined?(:Postgres)
  DataObjects::Sqlserver.logger = Rails.logger if DataObjects.const_defined?(:Sqlserver)
  DataObjects::Mysql.logger     = Rails.logger if DataObjects.const_defined?(:Mysql)
  DataObjects::Sqlite3.logger    = Rails.logger if DataObjects.const_defined?(:Sqlite3)
end

# Load the project model and migrate it if needed.
User
Role
Setting
Membership
Project

DataMapper.finalize
DataMapper.auto_migrate! unless DataMapper.repository(:default).storage_exists?(Project.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(Setting.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(User.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(Role.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(Membership.storage_name)
