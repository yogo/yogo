module DataMapper
  module Reflection
    module MysqlAdapter
      def get_type(db_type)
        db_type.gsub!(/\(\d*\)/, '')
        {
          'tinyint'     =>  Integer    ,
          'smallint'    =>  Integer    ,
          'int'         =>  Integer    ,
          'integer'     =>  Integer    ,
          'varchar'     =>  String     ,
          'char'        =>  String     ,
          'decimal'     =>  BigDecimal ,
          'double'      =>  Float      ,
          'float'       =>  Float      ,
          'datetime'    =>  DateTime   ,
          'date'        =>  Date       ,
          'boolean'     =>  Types::Boolean  ,
          'text'        =>  Types::Text
          }[db_type.split(' ')[0]]
      end

      def get_storage_names
        query = "SHOW FULL TABLES FROM #{options[:path][1..-1]} WHERE Table_type = 'BASE TABLE'"
        self.select(query).map {|item| item[0] }
      end

      def get_properties(table)
        results = Array.new
        query = "show columns from #{table} in #{options[:path][1..-1]};"
        send(:query, query).each do |column|
          results << {:name => column.field.downcase, :field => column.field, :type => get_type(column.type), :required => (column.null=='NO') ? true : false, :default => column.default, :key => ["PRI", "MUL"].include?(column.key) ? true: false}
        end
        results
      end
    end
  end
end