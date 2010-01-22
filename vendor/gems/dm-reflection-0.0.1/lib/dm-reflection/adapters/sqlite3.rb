module DataMapper
  module Reflection
    module Sqlite3Adapter

      def fetch_storage_names
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

      def fetch_attributes(table)
        results = Array.new
        # This should really create DataMapper Properties, I think
        self.select('PRAGMA table_info(%s)' % table).each do |column|
          results << ReflectedAttribute.new(column.name, TypeParser.parse(column.type), column.notnull, column.dflt_value, column.pk)
        end
        return results
      end
    end
  end
end