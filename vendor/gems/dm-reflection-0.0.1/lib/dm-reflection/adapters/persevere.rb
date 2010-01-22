module DataMapper
  module Reflection
    module PersevereAdapter
      RESERVED_CLASSNAMES = ['User','Transaction','Capability','File','Class']

      def fetch_storage_names
        @schemas = JSON.parse(self.get_schema)
        @schemas.map { |schema| schema['id'] unless RESERVED_CLASSNAMES.include?(schema['id']) }.compact
      end

      def fetch_attributes(table)
        results = Array.new
        schema = JSON.parse(self.get_schema(table))
        schema['properties'].each_pair do |key, value|
          results << ReflectedAttribute.new(key, TypeParser.parse(value['type']))
        end
        return results
      end
    end
  end
end