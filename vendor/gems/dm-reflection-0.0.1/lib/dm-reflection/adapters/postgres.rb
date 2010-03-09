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
        {
          'integer'                     =>  Integer        ,
          'varchar'                     =>  String         ,
          'character varying'           =>  String         ,
          'numeric'                     =>  BigDecimal     ,
          'double precision'            =>  Float          ,
          'datetime'                    =>  DateTime       ,
          'date'                        =>  Date           ,
          'boolean'                     =>  Types::Boolean ,
          'text'                        =>  Types::Text    ,
          'timestamp without time zone' =>  DateTime       ,
        }[db_type] || raise("unknown db type: #{db_type}")
      end

      ##
      # Get the list of table names
      #
      # @return [String Array] the names of the tables in the database.
      #
      def get_storage_names
        select(<<-SQL.compress_lines)
          SELECT "relname"
            FROM "pg_stat_user_tables"
           WHERE "schemaname" = 'public'
        SQL
      end

      # Returna list of columns in the primary key
      #
      # @param [String] the table name
      #
      # @return [Array<String>] the names of the columns in the primary key
      #
      def get_primary_keys(table)
        select(<<-SQL.compress_lines, table).to_set
              SELECT "key_column_usage"."column_name"
                FROM "information_schema"."table_constraints"
          INNER JOIN "information_schema"."key_column_usage" USING("constraint_schema", "constraint_name")
               WHERE "table_constraints"."constraint_type" = 'PRIMARY KEY'
                 AND "table_constraints"."table_name" = ?
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
        columns = select(<<-SQL.compress_lines, schema_name, table)
            SELECT "column_name"
                 , "data_type"
                 , "column_default"
                 , "is_nullable"
                 , "character_maximum_length"
                 , "numeric_precision"
              FROM "information_schema"."columns"
             WHERE "table_schema" = ?
               AND "table_name" = ?
          ORDER BY "ordinal_position"
        SQL

        primary_keys = get_primary_keys(table)

        columns.map do |column|
          type     = get_type(column.data_type)
          default  = column.column_default
          required = column.is_nullable == 'NO'
          key      = primary_keys.include?(column.column_name)
          length   = column.character_maximum_length

          if type == Integer && default
            if key
              type    = DataMapper::Types::Serial if default[/\Anextval/]
              default = nil
            else
              default = default.to_i
            end
          end

          if length
            length = (required ? 1 : 0)..length
          end

          attribute = {
            :name     => column.column_name.downcase,
            :type     => type,
            :required => required,
            :default  => default,
            :key      => key,
            :length   => length,
          }

          # TODO: use the naming convention to compare the name vs the column name
          unless attribute[:name] == column.column_name
            attribute[:field] = column.column_name
          end

          attribute
        end
      end

    end # module PostgresAdapter
  end # module Reflection
end # module DataMapper
