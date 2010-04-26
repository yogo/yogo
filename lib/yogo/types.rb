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
    @@HumanTM = { "Decimal"        => Float, 
                  "Integer"        => Integer,
                  "Text"           => DataMapper::Types::Text, 
                  "True/False"     => DataMapper::Types::Boolean, 
                  "Date"           => Date,
                  "Time"           => Time,
                  "DateTime"       => DateTime,
                  "File"           => DataMapper::Types::YogoFile,
                  "Image"          => DataMapper::Types::YogoImage }
    
    # DataMapper Type Map
    @@DMTM = { Float                      => "Decimal",
               BigDecimal                 => "Decimal",
               Integer                    => "Integer",
               DataMapper::Types::Text    => "Text",
               DataMapper::Types::Boolean => "True/False",
               Date                       => "Date",
               Time                       => "Time",
               DateTime                   => "DateTime",
               DataMapper::Types::Serial  => "Integer",
               DataMapper::Types::YogoFile     => "File",
               DataMapper::Types::YogoImage    => "Image" }

   # Google Visual Type Map
   @@GVTM = { Float                           => "number",
              BigDecimal                      => "number",
              Integer                         => "number",
              DataMapper::Types::Text         => "string",
              String                          => "string",
              DataMapper::Types::Boolean      => "string",
              Date                            => "date",
              Time                            => "string",
              DateTime                        => "datetime",
              DataMapper::Types::Serial       => "number",
              DataMapper::Types::YogoFile     => "string",
              DataMapper::Types::YogoImage    => "string" }

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