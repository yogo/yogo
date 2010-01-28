module DataMapper
  module Reflection
    ##
    # @todo The postgres adapter extensions have not been tested yet.
    # 
    module PostgresAdapter

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
          'INTEGER'           =>  Integer    ,
          'VARCHAR'           =>  String     ,
          'NUMERIC'           =>  BigDecimal ,
          'DOUBLE PRECISION'  =>  Float      ,
          'DATETIME'          =>  DateTime   ,
          'DATE'              =>  Date       ,
          'BOOLEAN'           =>  Types::Boolean  ,
          'TEXT'              =>  Types::Text
          }[db_type]
      end

      ##
      # Get the list of table names
      # 
      # @return [String Array] the names of the tables in the database.
      # 
      def get_storage_names
        self.select("select relname from pg_stat_user_tables WHERE schemaname='public'")
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
        repository(:defaults).adapter.send(:query, 'PRAGMA table_info(?)', table).each do |column|
          results << {:name => column.name.downcase, :field => column.name, :type => get_type(column.type), :nullable => column.notnull, :default_value => column.dflt_value, :key => column.pk}
        end
        return results
      end
      
    end # module PostgresAdapter
  end # module Reflection
end # module DataMapper