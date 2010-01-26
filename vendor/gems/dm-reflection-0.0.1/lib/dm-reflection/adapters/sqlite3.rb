module DataMapper
  module Reflection
    module Sqlite3Adapter
      
      def get_type(db_type)
        db_type.gsub!(/\(\d*\)/, '')
        {
           'INTEGER'     =>  Integer      ,
           'VARCHAR'     =>  String       ,
           'DECIMAL'     =>  BigDecimal   ,
           'FLOAT'       =>  Float        ,
           'TIMESTAMP'   =>  DateTime     ,
           'DATE'        =>  Date         ,
           'BOOLEAN'     =>  Types::Boolean,
           'TEXT'        =>  Types::Text
          }[db_type]
      end
      
      def get_storage_names
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

      def get_properties(table)
        results = Array.new
        # This should really create DataMapper Properties, I think
        self.select('PRAGMA table_info(%s)' % table).each do |column|
          results << {:name => column.name, :type => get_type(column.type), :required => column.notnull==0 ? false : true, :default => column.dflt_value, :key => column.pk==0 ? false : true}
        end
        return results
      end
    end
  end
end