# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: csv.rb
#
# @author Robbie Lamb robbie.lamb@gmail.com
module Yogo
  module Model
    ##
    # This file contans methods for importing and exporting CSV from a model
    # 
    # We expect a very particular format for the CSV files
    # 
    # The first three rows contains information about the types of data in the file.
    # 
    # The first row is a name for the data. This must start with a letter and may contain letters, numbers and underscores ('_').
    # 
    # The second row is the type of data the column contains. Valid types for this row is one of the Human Types defined in Yogo::Types
    # 
    # The third row contains unit information for the column
    # 
    # A special column labeled Yogo ID should not be touched by the end user
    # 
    # @see Yogo::Types
    # 
    # @author Robbie Lamb
    module Csv
      
      ##
      # Returns all CSV headers for this model
      # 
      # @example
      #   @model.to_csv
      # 
      # @return [String] The CSV headers in a string
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api public
      def to_csv
        self.properties.sort!
        
        FasterCSV.generate do |csv|
          csv << self.properties.map{|prop| prop.name == :yogo_id ? "Yogo ID" : prop.display_name.to_s.humanize }
          csv << self.properties.map{|prop| prop.name == :yogo_id ? "Internal Type" : Yogo::Types.dm_to_human(prop.type)}
          csv << self.properties.map{|prop| prop.name == :yogo_id ? "Please don't modify" : prop.units }
        end
      end
      
      ##
      # Returns yogo CSV headers for this model
      # 
      # @example
      #   @model.to_yogo_csv
      # 
      # @return [String] The CSV headers in a string
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api public
      def to_yogo_csv
        self.properties.sort!
        
        FasterCSV.generate do |csv|
          csv << ["Yogo ID"] + self.usable_properties.map{|prop| prop.display_name.to_s.humanize }
          csv << ["Internal Type"] + self.usable_properties.map{|prop| Yogo::Types.dm_to_human(prop.type)}
          csv << ["Please don't modify"] + self.usable_properties.map{|prop| prop.units }
        end
      end
      
      # Loads a CSV file into the model
      #
      # Loads CSV data into a model. If the csv file contains image paths, a path will need to be 
      # provided to locate the images.
      # 
      # TODO: Write a description of the CSV model here.
      #  
      # @example
      #   @model.load_csv_data(csv_data)
      # 
      # @param [String] csv_file
      #   Path the the CSV file
      # 
      # 
      # @return [Array] This will return an array of errors or an empty array if there were none
      # 
      # @author Robbie Lamb robbie.lamb@gmail.com
      # 
      # @api public
      def load_csv_data(csv_file)
        csv_data = FasterCSV.read(csv_file)
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

      private

      # Checks the columns in the file vs. the properties on the current model
      #
      #   If there are new columns, they are created.
      #   If there are columns that exist, but have different types, 
      #   we should throw an approporate error
      #
      # This should only be run after validate_csv_format on the file
      # 
      # @example errors = verify_csv_columns
      # 
      # @param [Array] csv_data
      #   Array of Arrays of CSV data.
      # 
      # @return [Array] Returns an array of errors. The array is empty if there are no errors
      # 
      # @api private
      def validate_csv_data(csv_data)
        errors = []
        properties_to_add = {}
        require_auto_migrate = false
        
        csv_data[0].each_index do |idx|
          attr_name = csv_data[0][idx].tableize.singularize.gsub(' ', '_')
          next if attr_name.eql?("yogo_id")
          cohersed_attr_name = "yogo__#{attr_name}"
          prop = properties[cohersed_attr_name]
          dm_type = Yogo::Types.human_to_dm(csv_data[1][idx])
          
          if dm_type.nil?
            errors << "The datatype #{csv_data[1][idx]} for the #{csv_data[0][idx]} column is invalid."
            
          elsif prop.nil?
            properties_to_add[attr_name.to_sym] = { :type => dm_type, 
                                                    :required => false, 
                                                    :prefix => 'yogo', 
                                                    :position => idx, 
                                                    :units => csv_data[2][idx]
                                                  }
            require_auto_migrate = true
            
          elsif prop.type != dm_type
            errors << "The datatype #{csv_data[1][idx]} for row #{idx} is different from what is currently in the database.\n To change the type in the database, please use the model editor."
          end
        end
        
        # If there are new properties and no errors, add them.
        if require_auto_migrate && errors.empty?
          properties_to_add.each_pair do |name,options|
            property(name, options.delete(:type), options)
          end
          self.auto_upgrade!

          properties.sort!
        end
        
        return errors
      end
      
    end # CSV
  end # Model
end # Yogo