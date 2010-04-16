module DataMapper
  module Reflection
    ##
    # Main reflection method reflects models out of a repository.
    # @param [Slug] repository is the key to the repository that will be reflected.
    # @param [Constant] namespace is the namespace into which the reflected models will be added
    # @param [Boolean] overwrite indicates the reflected models should replace existing models or not.
    # @return [DataMapper::Model Array] the reflected models.
    #
    def self.reflect(repository, namespace = Object, overwrite = false)
      adapter = DataMapper.repository(repository).adapter

      models  = []

      adapter.get_storage_names.each do |storage_name|
        namespace_parts = storage_name.split('__').map do |part|
          Extlib::Inflection.classify(part)
        end

        model_name = namespace_parts.pop

        namespace = if namespace_parts.any?
          Object.make_module(namespace_parts.join('::'))
        else
          Object
        end

        next if namespace.const_defined?(model_name) && !overwrite

        anonymous_model = DataMapper::Model.new do
          unless repository == DataMapper::Repository.default_name
            class_eval <<-RUBY, __FILE__, __LINE__
              def self.default_repository_name
                #{repository.inspect}
              end
            RUBY
          end
        end

        model = namespace.const_set(model_name, anonymous_model)

        adapter.get_properties(storage_name).each do |attribute|
          attribute.delete_if { |k,v| v.nil? }
          model.property(attribute.delete(:name).to_sym, attribute.delete(:type), attribute)
        end

        models << model
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
      # 
      # @api private
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
