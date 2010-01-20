module Databases
  module Persevere
    @@reserved_classes = ['User','Transaction','Capability','File','Class']
    
    def fetch_models
      JSON.parse(self.get_schema).map {|schema| schema['id']} - @@reserved_classes
    end
    
    def fetch_attributes(table)
      results = Array.new
      schema = JSON.parse(self.get_schema).select {|x| x['id'] == table}[0]
      schema['properties'].each_pair do |key, value|
        results << ReflectedAttribute.new(key, TypeParser.parse(value['type']))
      end
      puts results.inspect;
      return results
    end
    #tunnel
    
  end
end