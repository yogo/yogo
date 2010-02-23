module DataMapper
  module Reflection
    ##
    # Main reflection method reflects models out of a repository.
    # @param [Slug] repository is the key to the repository that will be reflected.
    # @param [Constant] namespace is the namespace into which the reflected models will be added
    # @param [Boolean] overwrite indicates the reflected models should replace existing models or not.
    # @return [DataMapper::Model Array] the reflected models.
    #
    def self.reflect(repository, namespace=Object, overwrite=false)
      adapter = DataMapper.repository(repository).adapter
      models = Array.new
      old_namespace = namespace
      adapter.get_storage_names.each do |model|
        namespace = old_namespace
        ctxtarray = model.split('__').map! do |item| 
          Extlib::Inflection.singularize(item.split("_").map { |word| word.capitalize }.join("")) 
        end
        # Create the scoping for the class, if it doesn't already exist.
        ctxtarray[0..-2].each do |mod|
          namespace.const_set(mod, Module.new) unless namespace.const_defined?(mod)
          namespace = Object.class_eval("#{namespace.name}::#{mod}", __FILE__, __LINE__)
        end
        
        class_name = ctxtarray[-1]
                
        if ! namespace.const_defined?(class_name) || (namespace.const_defined?(class_name) && overwrite)
          unamed_class = DataMapper::Model.new do 
              self.class_eval("def self.default_repository_name; :#{repository}; end")
          end
          new_model = namespace.const_set(class_name, unamed_class)
          adapter.get_properties(model).each do |attribute|
            attribute.delete_if { |k,v| v.nil? }
            new_model.property(attribute.delete(:name).to_sym, attribute.delete(:type), attribute)
          end
          models << new_model
        end
      end
      models
    end
  end # module Reflection

  module Adapters
    extendable do
      ##
      # Glue method that will register reflection extensions for adapters if the adapters are loaded.
      # 
      # @param [Constant] const_name is the constant defined by the adapter.
      # @api private
      # 
      def const_added(const_name)
        if DataMapper::Reflection.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::Reflection.const_get(const_name))
        end
        super
      end # const_added
    end # extendable block
  end # module Adapters
end # module DataMapper