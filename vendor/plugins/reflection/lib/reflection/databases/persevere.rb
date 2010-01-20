module Databases
  module Persevere
    @@reserved_classes = ['User','Transaction','Capability','File','Class']
    
    def fetch_models
      @schemas = JSON.parse(self.get_schema)
      @schemas.map { |schema| schema['id'][0..3] == "yogo" ? schema['id'] : nil }.compact
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