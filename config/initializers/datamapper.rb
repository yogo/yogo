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

require 'yogo/project_ext'


# Read the configuration from the existing database.yml file
config = Rails.configuration.database_configuration

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this

DataMapper.setup(:default, config[Rails.env])

# Alias :default to :yogo so things work well
DataMapper.setup(:collection_data, config["yogo_"+Rails.env])

# Map the datamapper logging to rails logging
DataMapper.logger             = Rails.logger
if Object.const_defined?(:DataObjects)
  DataObjects::Postgres.logger  = Rails.logger if DataObjects.const_defined?(:Postgres)
  DataObjects::Sqlserver.logger = Rails.logger if DataObjects.const_defined?(:Sqlserver)
  DataObjects::Mysql.logger     = Rails.logger if DataObjects.const_defined?(:Mysql)
  DataObjects::Sqlite3.logger    = Rails.logger if DataObjects.const_defined?(:Sqlite3)
end

# Load the project model and migrate it if needed.
# proj_model_file = File.join(RAILS_ROOT, "app", "models", "project.rb")
# require proj_model_file
Yogo::Project
User
Group
DataMapper.finalize
DataMapper.auto_migrate! unless DataMapper.repository(:default).storage_exists?(Yogo::Project.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(Group.storage_name) &&
                                DataMapper.repository(:default).storage_exists?(User.storage_name)
                                

admin_g = Group.first(:name => 'Administrators', :admin => true)
admin_g ||= Group.create(:name => 'Administrators', :admin => true)
create_g = Group.first(:name => "Create Projects", :admin => false)
create_g ||= Group.create(:name => 'Create Projects', :admin => false, :permissions => 'create_projects')

if admin_g.users.empty?
  u = User.create(:login => 'yogo', :password => 'change me', :password_confirmation => 'change me')
  u.groups << admin_g
  u.groups << create_g
  u.save
end