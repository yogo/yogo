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
      return results
    end
    
    # def parse_type(type)
    #       case type
    #       when "INTEGER"
    #         then "Integer"
    #       when "integer"
    #         then "Integer"
    #       when "FLOAT"
    #         then "Float"
    #       when "char"
    #         then "String"
    #       when "TIMESTAMP"
    #         then "DateTime"
    #       when "datetime"
    #         then "DateTime"
    #       when "boolean"
    #         then "Boolean"
    #       when /VARCHAR(\(\d{1,2}\)){0,1}/
    #         then "String"
    #       else
    #         type
    #       end
    #       return "String"
    #     end
    
  end
end