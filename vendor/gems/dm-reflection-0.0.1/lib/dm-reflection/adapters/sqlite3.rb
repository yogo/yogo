module DataMapper
  module Reflection
    module Sqlite3Adapter
      
      ##
      # Convert the database type into a DataMapper type
      # 
      # @todo This should be verified to identify all mysql primitive types 
      #       and that they map to the correct DataMapper/Ruby types.
      # 
      # @param [String] db_type type specified by the database
      # @return [Type] a DataMapper or Ruby type object.
      # 
      def get_type(db_type)
        db_type.gsub!(/\(\d*\)/, '')
        {
           'INTEGER'     =>  Integer      ,
           'VARCHAR'     =>  String       ,
           'DECIMAL'     =>  BigDecimal   ,
           'FLOAT'       =>  Float        ,
           'TIMESTAMP'   =>  DateTime     ,
           'DATE'        =>  Date         ,
           'BOOLEAN'     =>  Types::Boolean,
           'TEXT'        =>  Types::Text
          }[db_type]
      end

      ##
      # Get the list of table names
      # 
      # @return [String Array] the names of the tables in the database.
      #       
      def get_storage_names
        # This should return a new DataMapper resource.
        query = <<-QUERY
        SELECT name FROM sqlite_master
        WHERE type IN ('table','view') AND name NOT LIKE 'sqlite_%'
        UNION ALL
        SELECT name FROM sqlite_temp_master
        WHERE type IN ('table','view')
        QUERY
        self.select(query)
      end

      ##
      # Get the column specifications for a specific table
      # 
      # @todo Consider returning actual DataMapper::Properties from this. 
      #       It would probably require passing in a Model Object.
      # 
      # @param [String] table the name of the table to get column specifications for
      # @return [Hash] the column specs are returned in a hash keyed by `:name`, `:field`, `:type`, `:required`, `:default`, `:key`
      # 
      def get_properties(table)
        results = Array.new
        # This should really create DataMapper Properties, I think
        self.select('PRAGMA table_info(%s)' % table).each do |column|
          results << {:name => column.name.downcase, :field => column.name, :type => get_type(column.type), :required => column.notnull==0 ? false : true, :default => column.dflt_value, :key => column.pk==0 ? false : true}
        end
        return results
      end
      
    end # module Sqlite3Adapter
  end # module Reflection
end # module DataMapper