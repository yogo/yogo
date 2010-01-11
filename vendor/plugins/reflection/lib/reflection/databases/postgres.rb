module Databases
  module Postgres
    
    def fetch_models
      query
      send(:query, query)
    end
    
    def fetch_attributes(table)
      results = Array.new
      repository(:defaults).adapter.send(:query, 'PRAGMA table_info(?)', table).each do |column|
        results << ReflectedAttribute.new(column.name, parse_type(column.type), column.notnull, column.dflt_value, column.pk)
      end
      return results
    end

  end
end