# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: csv.rb
#
module Yogo
  class CSV
    # FIXME make me shorter
    # @return the result of csv_data eaching. Don't rely on this return value.
    # FIXME @api private, semipublic, or public
    # @param [DataMapper::Model] model  The model to load data into, creating instances of that model.
    # @param [Array<Arrays>] csv_data The CSV data to create models. It is expected that this data
    #                                   has been validated
    #
    # We don't care what it returns here.
    # 
    def self.load_data(model, csv_data)
      return unless validate_csv(csv_data).empty?
      csv_data[3..-1].each do |line|
        line_data = Hash.new
        if !line.empty?  #ignore blank lines
          csv_data[0].each_index do |i| 
            attr_name = csv_data[0][i].tableize.singularize.gsub(' ', '_')
            attr_name = "yogo__#{attr_name}" unless attr_name.eql?("yogo_id")
            prop = model.properties[attr_name]
            line_data[attr_name] = prop.typecast(line[i]) unless line[i].nil? || prop.nil?
          end
          model.create(line_data)
        end 
      end
    end
    
    ##
    # @return [Array] validates csv data conforms matches what the model expects
    # 
    # @param [DataMapper::Model] model The model to validate the csv against.
    # @param [Array of Arrays] csv_data The top three rows that define the structure of the CSV file.
    # 
    # @return [Boolean] Returns true if each of the columns in the CSV corresponds to an attribute with the same type of data.
    # FIXME @api private, semipublic, or public
    # 
    def self.validate_csv(csv_data)
      
      errors = []
      csv_data[1].each_with_index do |htype,idx|
        if Yogo::Types.human_to_dm(htype).nil?
          errors << "The datatype #{htype} for the #{csv_data[0][idx]} column is invalid."
        end
      end

      errors
    end
    
    ##
    # @return [String] Returns a string that is formatted as a CSV file that can be read back in by the Yogo Toolkit
    # 
    # @param [DataMapper::Model] model The model that is being downloaded as a csv file
    # @param [Boolean] include_data The boolean flag that will include all instances as data when true
    # 
    # FIXME @api private, semipublic, or public
    def self.make_csv(model, include_data=false)
      model.properties.sort!
      csv_output = FasterCSV.generate do |csv|
        csv << model.properties.map{|prop| prop.name == :yogo_id ? "Yogo ID" : prop.display_name.to_s.humanize }
        csv << model.properties.map{|prop| Yogo::Types.dm_to_human(prop.type)}
        csv << "Units will go in this row when supported; please do not modify the Yogo ID column."
      end

      model.all.each { |m| csv_output << m.to_csv } if include_data
      
      csv_output
    end
  end # class CSV
end # module Yogo