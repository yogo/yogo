# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: data_stream_column.rb
# The Data Stream Column model is where the streaming data parsing template information for a csv
# column is stored.
#

# Class for a Yogo Project. A project contains a name, a description, and access to all of the models
# that are part of the project.
class DataStreamColumn
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :type, String, :required => false
  property :original_var, String, :required => true
  property :column_number, Integer, :required => true
  
  has n, :variables, :through => Resource
  has n, :units, :through=> Resource
  has n, :data_streams, :model => "DataStream", :through => Resource
  
end