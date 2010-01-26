module Databases
  module MySQL
    
    def get_type(db_type)
      db_type.gsub!(/\(\d*\)/, '')
      {
         'INTEGER'     =>  Integer    ,
         'VARCHAR'     =>  String     ,
         'DECIMAL'     =>  BigDecimal ,
         'FLOAT'       =>  Float      ,
         'DATETIME'    =>  DateTime   ,
         'DATE'        =>  Date       ,
         'BOOLEAN'     =>  Types::Boolean  ,
         'TEXT'        =>  Types::Text
        }[db_type]
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
        puts "#{column.inspect}"
        results << {:name => column.field, :type => get_type(column.type), :required => column.null=='NO' ? false : true, :default => column.default, :serial => column.key=='PRI' ? true: false}
      end
      results
    end
  end
end