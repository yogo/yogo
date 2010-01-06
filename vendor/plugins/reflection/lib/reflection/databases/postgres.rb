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
    
    def parse_type(type)
      case type
      when "INTEGER"
        then "Serial"
      when "integer"
        then "Integer"
      when "char"
        then "String"
      when "datetime"
        then "DateTime"
      when "boolean"
        then "Boolean"
      else
        type
      end
    end

  end
end