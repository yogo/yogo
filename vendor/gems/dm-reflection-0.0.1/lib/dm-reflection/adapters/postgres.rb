module Databases
  module Postgres
    
    def get_storage_names
      query = "select relname from pg_stat_user_tables WHERE schemaname='public'"
      self.select(query)
    end
    
    def get_properties(table)
      results = Array.new
      repository(:defaults).adapter.send(:query, 'PRAGMA table_info(?)', table).each do |column|
        results << ReflectedAttribute.new(column.name, parse_type(column.type), column.notnull, column.dflt_value, column.pk)
      end
      return results
    end

  end
end