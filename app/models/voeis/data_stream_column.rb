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
class Voeis::DataStreamColumn < Yogo::Collection::Data

  def update_model
  end

  def generate_model
    model = DataMapper::Model.new
    model.extend(Yogo::Collection::Base::Model)
    model.send(:include, Yogo::Collection::Base::Model::InstanceMethods)
    model.collection = self
    model.class_eval do
      property :id, Serial
      property :name, String, :required => true
      property :type, String, :required => false
      property :original_var, String, :required => true
      property :column_number, Integer, :required => true

      # has n, :variables, :through => Resource
      # has n, :units, :through=> Resource
      # has n, :data_streams, :model => "DataStream", :through => Resource
    end
    model.auto_upgrade!
    model
  end
end