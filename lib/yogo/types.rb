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
                  "Text"           => String, 
                  "True/False"     => DataMapper::Types::Boolean, 
                  "Date"           => Date,
                  "Time"           => Time,
                  "DateTime"       => DateTime,
                  "File"           => DataMapper::Types::YogoFile }
                  
    @@DMTM = { Float                      => "Decimal",
               BigDecimal                 => "Decimal",
               Integer                    => "Integer",
               String                     => "Text",
               DataMapper::Types::Boolean => "True/False",
               Date                       => "Date",
               Time                       => "Time",
               DateTime                   => "DateTime",
               DataMapper::Types::Serial  => "Integer",
               DataMapper::Types::YogoFile     => "File" }

   @@GVTM = { Float                      => "number",
              BigDecimal                 => "number",
              Integer                    => "number",
              String                     => "string",
              DataMapper::Types::Boolean => "string",
              Date                       => "date",
              Time                       => "string",
              DateTime                   => "datetime",
              DataMapper::Types::Serial  => "number",
              DataMapper::Types::YogoFile     => "string" }

    def self.dm_to_human(dmtype)
      @@DMTM[dmtype]
    end
    
    def self.human_to_dm(humantype)
      @@HumanTM[humantype.split('/').each{|t| t.capitalize }.join('/')]
    end
    
    def self.dm_to_gv(dmtype)
      @@GVTM[dmtype]
    end
    
    def self.human_types
      @@HumanTM.keys
    end
    
    def self.dm_types
      @@DMTM.keys
    end
  end # Class Types
end # module Yogo