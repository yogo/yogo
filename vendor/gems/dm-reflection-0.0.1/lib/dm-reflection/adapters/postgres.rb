module Databases
  module Postgres

    def get_type(db_type)
      db_type.gsub!(/\(\d*\)/, '')
      {
         'INTEGER'           =>  Integer    ,
         'VARCHAR'           =>  String     ,
         'NUMERIC'           =>  BigDecimal ,
         'DOUBLE PRECISION'  =>  Float      ,
         'DATETIME'          =>  DateTime   ,
         'DATE'              =>  Date       ,
         'BOOLEAN'           =>  Types::Boolean  ,
         'TEXT'              =>  Types::Text
        }[db_type]
    end
      
    def get_storage_names
      query = "select relname from pg_stat_user_tables WHERE schemaname='public'"
      self.select(query)
    end
    
    def get_properties(table)
      results = Array.new
      repository(:defaults).adapter.send(:query, 'PRAGMA table_info(?)', table).each do |column|
        results << {:name => column.name, :type => get_type(column.type), :nullable => column.notnull, :default_value => column.dflt_value, :serial => column.pk}
      end
      return results
    end

  end
end