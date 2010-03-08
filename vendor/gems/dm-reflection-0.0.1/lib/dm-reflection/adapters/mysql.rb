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
        # TODO: return a Hash with the :type, :min, :max and other
        # options rather than just the type

        db_type.match(/\A(\w+)/)
        {
          'tinyint'     =>  Integer    ,
          'smallint'    =>  Integer    ,
          'mediumint'   =>  Integer    ,
          'int'         =>  Integer    ,
          'bigint'      =>  Integer    ,
          'integer'     =>  Integer    ,
          'varchar'     =>  String     ,
          'char'        =>  String     ,
          'enum'        =>  String     ,
          'decimal'     =>  BigDecimal ,
          'double'      =>  Float      ,
          'float'       =>  Float      ,
          'datetime'    =>  DateTime   ,
          'timestamp'   =>  DateTime   ,
          'date'        =>  Date       ,
          'boolean'     =>  Types::Boolean,
          'tinyblob'    =>  Types::Text,
          'blob'        =>  Types::Text,
          'mediumblob'  =>  Types::Text,
          'longblob'    =>  Types::Text,
          'tinytext'    =>  Types::Text,
          'text'        =>  Types::Text,
          'mediumtext'  =>  Types::Text,
          'longtext'    =>  Types::Text,
        }[$1] || raise("unknown type: #{db_type}")
      end

      ##
      # Get the list of table names
      #
      # @return [String Array] the names of the tables in the database.
      #
      def get_storage_names
        # This gets all the non view tables, but has to strip column 0 out of the two column response.
        select("SHOW FULL TABLES FROM #{options[:path][1..-1]} WHERE Table_type = 'BASE TABLE'").map { |item| item.first }
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
        # TODO: use SHOW INDEXES to find out unique and non-unique indexes

        select("SHOW COLUMNS FROM #{table} IN #{options[:path][1..-1]};").map do |column|
          type           = get_type(column.type)
          auto_increment = column.extra == 'auto_increment'

          if type == Integer && auto_increment
            type = DataMapper::Types::Serial
          end

          attribute = {
            :name     => column.field.downcase,
            :type     => type,
            :required => column.null == 'NO',
            :default  => column.default,
            :key      => column.key == 'PRI',
          }

          # TODO: use the naming convention to compare the name vs the column name
          unless attribute[:name] == column.field
            attribute[:field] = column.field
          end

          attribute
        end
      end
    end # module MysqlAdapter
  end # module Reflection
end # module DataMapper
