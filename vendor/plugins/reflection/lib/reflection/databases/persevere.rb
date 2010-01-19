module Databases
  module Persevere
    
    def fetch_models
      self.get_schema.map {|schema| schema['id']}
    end
    
    def fetch_attributes(table)
      results = Array.new
      schema = self.get_schema.select {|x| x['id'] == table}[0]
      schema['properties'].each_pair do |key, value|
        results << ReflectedAttribute.new(key, TypeParser.parse(value['type']))
      end
      puts results.inspect;
      return results
    end
    #tunnel
    
  end
end