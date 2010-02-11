# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: datamapper.rb
# 
#

# Require custom extensions to datamapper.
require 'datamapper/property'
require 'datamapper/search'
require 'datamapper/paginate'
require 'datamapper/factory'
require 'datamapper/types/yogo_file'

# Read the configuration from the existing database.yml file
config = Rails.configuration.database_configuration

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this 
DataMapper.setup(:default, config[Rails.env])

# Alias :default to :yogo so things work well
#DataMapper::Repository.adapters[:yogo] = DataMapper::repository(:default)
DataMapper.setup(:yogo, config[Rails.env])

# Setup the persevere repository for cool fun research!
DataMapper.setup(:example, config["example"])

# Map the datamapper logging to rails logging
DataMapper.logger             = Rails.logger
DataObjects::Postgres.logger  = Rails.logger if DataObjects.const_defined?(:Postgres)
DataObjects::Sqlserver.logger = Rails.logger if DataObjects.const_defined?(:Sqlserver)
DataObjects::Mysql.logger     = Rails.logger if DataObjects.const_defined?(:Mysql)
DataObjects::Sqlite.logger    = Rails.logger if DataObjects.const_defined?(:Sqlite)
