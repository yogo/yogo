# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: data_stream.rb
# The Data Stream model is where the streaming data parsing templates are stores.  
# 

# Class for a Yogo Project. A project contains a name, a description, and access to all of the models
# that are part of the project.
class DataStream
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true, :unique => true
  property :description, Text, :required => false
  property :filename, String, :required => true
  
  validates_is_unique   :name
  
  before :destroy, :delete_data_stream_columns!
  
  has one, :project
  has one, :site
  has n, :data_stream_columns

 # Loads a CSV file into the streaming data model
  #
  # Loads CSV data into the streaming data model. 
  # 
  # TODO: Write a description of the CSV streaming data model here.
  #  
  # @example
  #   @data_stream_model.load_csv_data_stream(csv_data)
  # 
  # @param [String] csv_file
  #   Path the the CSV file
  # 
  # 
  # @return [Array] This will return an array of errors or an empty array if there were none
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author Sean Cleveland sean.b.cleveland@gmail.com
  # 
  # @api public
  def load_csv_data_stream(csv_file, project, site)
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)
    
    errors = validate_csv_data(csv_data)
    
    all_objects = []
    if errors.empty?
      attr_names = csv_data[0].map{|name| name.tableize.singularize.gsub(' ', '_') }
      attr_names = attr_names.map {|name| name.eql?("yogo_id") ? "yogo_id" : "yogo__#{name}" }
      props = attr_names.map {|name| properties[name] }
      
      csv_data[3..-1].each_index do |idx|
        line = csv_data[idx+3]
        line_data = Hash.new
        if !line.empty?  #ignore blank lines
          csv_data[0].each_index do |i| 
            prop = props[i]
            
            if prop.type == DataMapper::Types::YogoFile || prop.type == DataMapper::Types::YogoImage
              column_value = File.open(File.join(path, line[i]))
              line_data[attr_names[i]] = column_value unless column_value.nil? || prop.nil?
            else
              line_data[attr_names[i]] = prop.typecast(line[i]) unless line[i].nil? || prop.nil?
            end  
          end
          obj = self.new(line_data)
          if obj.valid?
            all_objects << obj
          else
            obj.errors.each_pair do |key,value|
              # debugger
              value.each do |msg|
                errors << "Line #{idx+3} column #{key.to_s.gsub("yogo__", '')} #{msg.split[2..-1].join}"
              end
            end
          end
        end 
      end
    end
    all_objects.each{|o| o.save } if errors.empty?
    return errors
  end
  
end