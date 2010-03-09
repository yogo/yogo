module DataMapper
  module Reflection
    module Sqlite3Adapter

      ##
      # Convert the database type into a DataMapper type
      #
      # @todo This should be verified to identify all sqlite3 primitive types
      #       and that they map to the correct DataMapper/Ruby types.
      #
      # @param [String] db_type type specified by the database
      # @return [Type] a DataMapper or Ruby type object.
      #
      def get_type(db_type)
        db_type.match(/\A(\w+)/)
        {
           'INTEGER'     =>  Integer      ,
           'VARCHAR'     =>  String       ,
           'DECIMAL'     =>  BigDecimal   ,
           'FLOAT'       =>  Float        ,
           'TIMESTAMP'   =>  DateTime     ,
           'DATE'        =>  Date         ,
           'BOOLEAN'     =>  Types::Boolean,
           'TEXT'        =>  Types::Text
          }[$1] || raise("unknown db type: #{db_type}")
      end

      ##
      # Get the list of table names
      #
      # @return [String Array] the names of the tables in the database.
      #
      def get_storage_names
        select(<<-SQL.compress_lines)
            SELECT name
              FROM (SELECT * FROM sqlite_master UNION SELECT * FROM sqlite_temp_master)
             WHERE type IN('table', 'view')
               AND name NOT LIKE 'sqlite_%'
          ORDER BY name
        SQL
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
        # TODO: consider using "SELECT sql FROM sqlite_master WHERE tbl_name = ?"
        # and parsing the create table statement since it will provide
        # more information like if a column is auto-incrementing, and what
        # indexes are used.

        select('PRAGMA table_info(%s)' % table).map do |column|
          type    = get_type(column.type)
          default = column.dflt_value

          if type == Integer && default
            default = default.to_i
          end

          attribute = {
            :name     => column.name.downcase,
            :type     => type,
            :required => column.notnull == 1,
            :default  => default,
            :key      => column.pk == 1,
          }

          # TODO: use the naming convention to compare the name vs the column name
          unless attribute[:name] == column.name
            attribute[:field] = column.name
          end

          attribute
        end
      end

    end # module Sqlite3Adapter
  end # module Reflection
end # module DataMapper
