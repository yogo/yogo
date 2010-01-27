module DataMapper
  module Reflection
    module MysqlAdapter
      
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
          'tinyint'     =>  Integer    ,
          'smallint'    =>  Integer    ,
          'int'         =>  Integer    ,
          'integer'     =>  Integer    ,
          'varchar'     =>  String     ,
          'char'        =>  String     ,
          'decimal'     =>  BigDecimal ,
          'double'      =>  Float      ,
          'float'       =>  Float      ,
          'datetime'    =>  DateTime   ,
          'date'        =>  Date       ,
          'boolean'     =>  Types::Boolean  ,
          'text'        =>  Types::Text
          }[db_type.split(' ')[0]]
      end

      ##
      # Get the list of table names
      # 
      # @return [String Array] the names of the tables in the database.
      # 
      def get_storage_names
        # This gets all the non view tables, but has to strip column 0 out of the two column response.
        self.select("SHOW FULL TABLES FROM #{options[:path][1..-1]} WHERE Table_type = 'BASE TABLE'").map { |item| item[0] }
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
        send(:query, "show columns from #{table} in #{options[:path][1..-1]};").each do |column|
          results << {  :name       => column.field.downcase, 
                        :field      => column.field, 
                        :type       => get_type(column.type), 
                        :required   => (column.null=='NO') ? true : false, 
                        :default    => column.default, 
                        :key        => ["PRI", "MUL"].include?(column.key) ? true: false
                     }
        end
        results
      end
    end # module MysqlAdapter
  end # module Reflection
end # module DataMapper