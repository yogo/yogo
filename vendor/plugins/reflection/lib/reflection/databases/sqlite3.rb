module Databases
  module Sqlite3
    
    def fetch_models
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
      self.select('PRAGMA table_info(%s)' % table).each do |column|
        results << ReflectedAttribute.new(column.name, TypeParser.parse(column.type), column.notnull, column.dflt_value, column.pk)
      end
      return results
    end

  end
end