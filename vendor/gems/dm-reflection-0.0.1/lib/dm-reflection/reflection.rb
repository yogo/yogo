require 'ruby-debug'
module DataMapper

  module Model
    def is_reflected?
      false
    end
  end

  module Reflection

    def self.make_model_string(desc, repo)
      model_description = []
      class_name = desc['id'][-1].singular.camel_case
      
      # We start the class definition by wrapping the appropriate number of module definitions
      desc['id'][0..-2].each do |mod|
        model_description << "module #{mod.capitalize.camel_case}"
      end
      
      model_description << "class #{class_name}" 
      model_description << "include DataMapper::Resource"
      model_description << "def self.default_repository_name; :#{repo}; end"
      model_description << "def self.is_reflected?; true; end"

      # This needs to be pushed into the adapter to get the appropriate serial field and extended attributes
      model_description << "property :id, Serial"
      desc['properties'].each_pair do |key, value|
        # This should lookup the attribute/type mapping from the adapter
        prop = value['type'] ? \
        "property :#{key}, #{TypeParser.parse(value['type'])}" : \
        "property :#{key}, String"
        prop += ", :key => true" if key == "id"
        model_description << prop
      end
      
      desc['id'].each do
        model_description << 'end'
      end
      return model_description.join("\n")
    end

    def self.reflect(repository, overwrite=false)
      adapter = DataMapper.repository(repository).adapter
      models = Array.new
            
      # For each model
      adapter.fetch_models.each do |model|
        description = Hash.new
        # Get the attributes
        attributes = adapter.fetch_attributes(model)
        #description.update( {'id' => "#{model}"} )
        description.update( {'id' => model.split('/') } )
        description.update( {'properties' => {}} )
        attributes.each do |attribute|
          if attribute.name == 'id'
            description['properties'].update( {attribute.name => {'type' => 'String'}} )
          else
            description['properties'].update( {attribute.name => {'type' => attribute.type}} )
          end
        end
        desc = make_model_string(description, repository)
        models << Object.class_eval(desc).model
      end
      models
    end
  end
  
  module Adapters
    
    extendable do
  
      # @api private
      def const_added(const_name)
        if DataMapper::Reflection.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::Reflection.const_get(const_name))
        end
  
        super
      end
    end
  end # module Adapters
end # module DataMapper