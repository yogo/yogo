# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: types.rb
# Creating a single place to map between Application data types and DataMapper datatypes.
#
module Yogo
  class Types
    # Constant for the supported Human readable datatypes
    @@HumanTM = { "Decimal"        => DataMapper::Property::Float, 
                  "Integer"        => DataMapper::Property::Integer,
                  "Text"           => DataMapper::Property::Text, 
                  "TrueFalse"      => DataMapper::Property::Boolean, 
                  "Date"           => DataMapper::Property::Date,
                  "Time"           => DataMapper::Property::Time,
                  "DateTime"       => DataMapper::Property::DateTime,
                  "File"           => DataMapper::Property::YogoFile,
                  "Image"          => DataMapper::Property::YogoImage }
    
    # DataMapper Type Map
    @@DMTM = { DataMapper::Property::Float        => "Decimal",
               DataMapper::Property::Decimal   => "Decimal",
               DataMapper::Property::Integer      => "Integer",
               DataMapper::Property::Text         => "Text",
               DataMapper::Property::Boolean      => "TrueFalse",
               DataMapper::Property::Date         => "Date",
               DataMapper::Property::Time         => "Time",
               DataMapper::Property::DateTime     => "DateTime",
               DataMapper::Property::Serial       => "Integer",
               DataMapper::Property::YogoFile     => "File",
               DataMapper::Property::YogoImage    => "Image" }

   # Google Visual Type Map
   @@GVTM = { DataMapper::Property::Float        => "number",
              DataMapper::Property::Decimal   => "number",
              DataMapper::Property::Integer      => "number",
              DataMapper::Property::Text         => "string",
              DataMapper::Property::String       => "string",
              DataMapper::Property::Boolean      => "string",
              DataMapper::Property::Date         => "date",
              DataMapper::Property::Time         => "string",
              DataMapper::Property::DateTime     => "datetime",
              DataMapper::Property::Serial       => "number",
              DataMapper::Property::YogoFile     => "string",
              DataMapper::Property::YogoImage    => "string" }

    ##
    # Returns the human readable Yogo string of DataMappers datatype 
    #
    # @example 
    #  @model.dm_to_human("Float")
    #   returns the string "Decimal"
    #
    # @param [String] dmtype
    #   a string containing a DataMapper type, like "Float" or "Integer"
    #
    # @return [String] returns the human readable (Yogo) version of the DataMapper type
    #
    # @author Yogo Team
    #
    # @api public
    #
    def self.dm_to_human(dmtype)
      @@DMTM[dmtype]
    end
    
    ##
    # Returns the DataMappers datatype from a Yogo type string
    #
    # @example 
    #  @model.human_to_dm("Decimal")
    #   returns the string "Float"
    #
    # @param [String] humantype
    #   a string containing a Yogo type, like "Decimal" or "True/False"
    #
    # @return [String] returns DataMapper type corresponding to the Yogo type
    #
    # @author Yogo Team
    #
    # @api public
    #
    def self.human_to_dm(humantype)
      @@HumanTM[humantype.split('/').each{|t| t.capitalize }.join('/')]
    end
    
    ##
    # Returns the Google Visual Type string corresponding to a DataMappers datatype 
    #
    # @example 
    #  @model.dm_to_gv("Float")
    #   returns the string "number"
    #
    # @param [String] dmtype
    #   a string containing a DataMapper type, like "Float" or "Integer"
    #
    # @return [String] returns the Google Visual Type version of the DataMapper type
    #
    # @author Yogo Team
    #
    # @api public
    def self.dm_to_gv(dmtype)
      @@GVTM[dmtype]
    end
    
    ##
    # Returns an Array of the Human Types
    # 
    # @example 
    #  @model.human_types
    #
    # @return [Array] returns an array of the Human Types
    #
    # @author Yogo Team
    #
    # @api public
    def self.human_types
      @@HumanTM.keys
    end
    
    ##
    # Returns an Array of the DataMapper Types that have corresponding Human types
    # 
    # @example 
    #  @model.dm_types
    #
    # @return [Array] returns an array of the DataMapper Types that have corresponding Human types
    #
    # @author Yogo Team
    #
    # @api public
    def self.dm_types
      @@DMTM.keys
    end
  end # Class Types
end # module Yogo