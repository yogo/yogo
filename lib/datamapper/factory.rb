#This is my factory. Vadka sqweu driver you buddy.
module DataMapper
class Factory
  
  def self.create_model_from_json_schema(json_schema, repository_name = :default, options = {})
    json_schema = JSON.parse(json_schema) unless json_schema.is_a?(Hash)
    
    scoping       = json_schema['id'].split('/').collect{|i| i.singularize.camel_case }
    module_names  = scoping[0..-2]
    class_name    = scoping[-1]
    properties    = json_schema['properties']
    
    class_definition = ""
    
    module_names.each{|mod| class_definition += "module #{mod}\n" }
    
    class_definition += "class #{class_name}\n"
    class_definition += "  include DataMapper::Resource\n"
    class_definition += "def self.default_repository_name; :#{repository_name}; end\n"
    
    class_definition += "property :id, String, :serial => true\n"
    properties.each_pair do |property, options|
      class_definition += "property :#{property}, #{to_dm_type(options)}"
      class_definition += (", :required => %s" % (options["optional"].eql?(true) ? "false" : "true"))
      #MIN
      #MAX
      
      class_definition += "\n"
    end
    
    class_definition += "end\n"
    
    
    module_names.each{|mod| class_definition += "end\n" }
    
    class_definition
  end
  
  private
  
   def self.to_dm_type(type_properties)
      # A case statement doesn't seem to be working when comparing classes.
      # That's why we're using a if elseif block.
      case type_properties['type'].downcase
      when "string"  then "String"
      when "integer" then "Integer"
      when "number"  then "Float"
      when "boolean" then "DataMapper::Types::Boolean"
      when "any"     then "String"
      else raise Exception.new("Type #{type_properties['type']} is not defined.")
      
      end
    end
  
end
end