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
        results << ReflectedAttribute.new(col.field, TypeParser.parse(col.type), col.null, col.default, col.key)
      end
      results
    end
  end
end