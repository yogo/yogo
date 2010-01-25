module DataMapper
  module Reflection
    module PersevereAdapter      
      def get_type(db_type, format = nil)
        db_type.gsub!(/\(\d*\)/, '')
        case db_type
        when 'serial'    then DataMapper::Types::Serial
        when 'integer'   then Integer
        when 'number'    then BigDecimal 
        when 'number'    then Float      
        when 'boolean'   then DataMapper::Types::Boolean
        when 'string'    then 
          case format
            when nil         then String
            when 'date-time' then DateTime
            when 'date'      then Date
            when 'time'      then Time
          end
        end
      end

      def get_storage_names
        @schemas = self.get_schema
        @schemas.map { |schema| schema['id'] }
      end

      def get_properties(table)
        results = Array.new
        schema = self.get_schema(table)[0]
        schema['properties'].each_pair do |key, value|
          results << {:name => key, :type => get_type(value['type'], value['format']), :required => !value['optional'], :default => value['default'], :key => value.has_key?('index') && value['index'] }
        end
        return results
      end
    end
  end
end