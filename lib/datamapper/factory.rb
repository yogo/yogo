#This is my factory. Vadka sqweu driver you buddy.
module DataMapper
class Factory
  
  def self.build(description, repository_name = :default, options = {})
    desc =  describe_model_from_json_schema(description, repository_name, options)
    puts "DESCRIPTION"
    puts desc
    Object.class_eval(desc).model # just return the model, instead of last eval'd model property
  end
  
  # This will look for a hash with certain keys in it. Those keys are:
  # :modules    =>  [], and array of modules the class will be namespaced into by the order they are in the array
  # :name       =>  'ClassName' The name of the class in camel case format.
  # :properties =>  {}, a hash of properties
  # 
  #     Each key in the property hash is the name of the property.
  #     if the key points to a string or symbol, that will be used as the property type.
  #     The property type should be a valid DataMapper property type.
  #
  #     If the key points to a hash, 
  #
  #
  #  NOT Implemented
  # :associations => {} associations this class has with other classes.
  #
  # This returns a datamapper model. 
  def self.build_model_from_hash(desc, repository_name = :default, options = {})
    module_names = desc[:modules] || []
    class_name   = desc[:name]
    properties   = desc[:properties]
    
    class_definition = ''
    
    module_names.each{|mod| class_definition += "module #{mod}\n" }
    
    class_definition += "class #{class_name}\n"
    class_definition += "  include DataMapper::Resource\n"
    
    class_definition += "def self.default_repository_name; :#{repository_name}; end\n"

    properties.each_pair do |property, opts|
      if opts.is_a?(Hash)

        class_definition += "property :#{property}, #{opts['type']}"
        opts.reject{|k,v| k=='type'}.each_pair{|key,value| class_definition += ", :#{key} => #{value}"}
      else
        class_definition += "property :#{property}, #{opts}"
      end
     
      class_definition += "\n"
    end
    
    class_definition += "end\n"
    
    module_names.each{|mod| class_definition += "end\n" }

    model = Object.class_eval(class_definition).model
    model.send(:include, options[:modules]) if options.has_key?(:modules)
    
    return model
  end
  
  def self.describe_model_from_json_schema(json_schema, repository_name = :default, options = {})
    json_schema = JSON.parse(json_schema) unless json_schema.is_a?(Hash)
    
    scoping       = json_schema['id'].split('/').collect{|i| i.singularize.camel_case }
    module_names  = scoping[0..-2]
    class_name    = scoping[-1]
    properties    = json_schema['properties']

    return nil unless properties #we can't handle property-less models... yet

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
  
  def self.make_model_from_csv(class_name, spec_array)
    scopes = class_name.split('::')
    spec_hash = { :name => scopes[-1],
                  :properties => Hash.new }
    spec_hash[:modules] = scopes[0..-2] unless scopes.length.eql?(1)                  
    spec_array[0].each_index do |idx|
      spec_hash[:properties].merge!({ spec_array[0][idx].tableize.singular => { "type" => spec_array[1][idx], "required" => false, "key" => true } } ) 
    end

    self.build_model_from_hash(spec_hash, :yogo)
  end
  
  private
  
   def self.to_dm_type(type_properties)
      # A case statement doesn't seem to be working when comparing classes.
      # That's why we're using a if elseif block.
      case type_properties['type'].downcase
      when "string"  then "String"
      when "integer" then "Integer"
      when "float"   then "Float"
      when "number"  then "Float"
      when "boolean" then "DataMapper::Types::Boolean"
      when "any"     then "String"
      else raise Exception.new("Type #{type_properties['type']} is not defined.")
      end
    end
  
end
end