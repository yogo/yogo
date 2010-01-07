
module DataMapper
  module Model
    # module Json
      def to_json_schema
        # usable_properties = properties.select{|p| p.name != :id }
        # "{ \"id\" : \"#{self.name}\",\n \t\"properties\": {\n" + usable_properties.collect{|p| "\t\t\"#{p.name}\" : { \"type\" : \"#{to_json_type(p.type)}\" }" }.join(",\n ") + "\n\t}\n}"
        to_json_schema_compatable_hash.to_json
      end

      private
      
      def to_json_schema_compatable_hash
        usable_properties = properties.select{|p| p.name != :id }
        schema_hash = {}
        schema_hash['id'] = self.storage_name
        properties_hash = {}
        properties.each{|p| properties_hash[p.name]=to_json_type(p.type) if p.name != :id}
        schema_hash['properties'] = properties_hash

        return schema_hash
      end
      
      def to_json_type(type)
        # A case statement doesn't seem to be working when comparing classes.
        # That's why we're using a if elseif block.
        if type == DataMapper::Types::Serial
          return "string"
        elsif type == String
          return "string"
        elsif type == Float
          return "number"
        elsif type == DataMapper::Types::Boolean
          return "boolean"
        elsif type == DataMapper::Types::Text
          elsif type == "string"
        elsif type == Integer
          return "integer"
        else 
          return"string"
        end
      end
    # end
  end
end