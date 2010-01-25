module Databases
  module Postgres
    # TODO : Update to the new api.
    
    def get_storage_names
      query = "select relname from pg_stat_user_tables WHERE schemaname='public'"
      self.select(query)
    end
    
    def get_properties(table)
      results = Array.new
      repository(:defaults).adapter.send(:query, 'PRAGMA table_info(?)', table).each do |column|
        results << {:name => column.name, :type => column.type, :nullable => column.notnull, :default_value => column.dflt_value, :serial => column.pk}
      end
      return results
    end

  end
end