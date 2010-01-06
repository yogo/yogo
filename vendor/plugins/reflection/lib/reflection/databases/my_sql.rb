module Databases
  module MySQL
    
    def fetch_models
      database = self.options['database']
      query = "SHOW TABLES FROM #{database}"
      self.select(query)
    end
    
    def fetch_attributes(table)
      results = Array.new
      database = DataMapper::Reflection.adapter.options['database']
      query = "show columns from #{table} in #{database};"
      repository(:defaults).adapter.send(:query, query).each do |col|
        results << ReflectedAttribute.new(col.field, parse_type(col.type), col.null, col.default, col.key)
      end
      results
    end
    
    def parse_type(type)
      case type
      when "tinyint(4)"
        then "Integer"
      when "int(11)"
        then "Integer"
      when "varchar(255)"
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