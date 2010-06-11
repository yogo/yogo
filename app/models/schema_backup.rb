# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: schema_backup.rb
# The project model is where the action starts.  Every yogo instance starts with a 
# a project and the project is where the models and data will be namespaced.

# It is with a heavy heart I do this. Persevere has some problems remembering JSON schemas we give to it.
# This class is a backup of the schemas. If persevere forgets, we can pull them from here and put them back.
class SchemaBackup
  include DataMapper::Resource
  
  property :id,     Serial
  property :name,   String, :unique => true
  property :schema, Text
  
  ##
  # Gets a SchemaBackup or creates one of the specified name
  # 
  # @example
  #   SchemaBackup.get_or_create_by_name('BaconChiliCheeseBurgers')
  # 
  # @param [String] name
  #   The name of the backup schema to look for
  # 
  # @return [SchemaBackup]
  #   The backup object
  # 
  # @author lamb
  # 
  # @api public
  def self.get_or_create_by_name(name)
    results = all(:name => name)
    return results[0] unless results.empty?
    return self.create(:name => name)
  end
  
end