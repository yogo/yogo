module Databases
  module MySQL
    
    # TODO : update this to the new use
    def get_type(db_type)
      types = type_map
      types.each_pair do |dm_type, type_info|
        if type_info[:primitive] == db_type
          return dm_type
        end
      end
      nil
    end
    
    def get_storage_names
      database = self.options['database']
      query = "SHOW TABLES FROM #{database}"
      self.select(query)
    end
    
    def get_properties(table)
      results = Array.new
      database = DataMapper::Reflection.adapter.options['database']
      query = "show columns from #{table} in #{database};"
      repository(:defaults).adapter.send(:query, query).each do |column|
        results << {:name => column.field, :type => column.type, :nullable => column.null, :default_value => column.default, :serial => column.key}
      end
      results
    end
  end
end