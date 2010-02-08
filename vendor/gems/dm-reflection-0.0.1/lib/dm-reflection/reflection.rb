module DataMapper
  module Reflection
    ##
    # Converts an internal hash into a string
    # 
    # @param [Hash] desc is a hash of name and attributes pulled out of the adapter.
    # @param [Slug] repo is the key to the repository this model will live in.
    # @return [String] a string defining the datamapper model.
    # 
    def self.make_model_string(desc, repo)
      model_description = []
      storage_name = desc['id']
    
      mscope = desc['id'].split('/').map{ |scope| scope.capitalize.camelcase }
      mscope[0..-2].each do |scope|
        model_description << "module #{scope}"
      end
    
      model_description << "class #{mscope[-1]}" 
      model_description << "include DataMapper::Resource"
      model_description << "storage_names[:#{repo}] = '#{storage_name}';"
      model_description << "def self.default_repository_name; :#{repo}; end"
    
      desc['properties'].each_pair do |key, value|
        line  = "property :#{key}, #{value[:type]}"
        line += ", :field => '#{value[:field]}'" unless value[:field].blank?
        line += ", :key => #{value[:key]}" unless value[:key].blank?
        line += ", :required => #{value[:required]}" unless value[:required].blank?
        line += ", :default => #{value[:default]}" unless value[:default].blank?
        line += ", :serial => #{value[:serial]}" unless value[:serial].blank?
        model_description << line
      end
      model_description << "end # Class #{mscope[-1]}"
    
      mscope[0..-2].each do |scope|
        model_description << "end # Module #{scope}"
      end
      return model_description.join("\n")
    end

    ##
    # Main reflection method reflects models out of a repository.
    # @param [Slug] repository is the key to the repository that will be reflected.
    # @param [Boolean] overwrite indicates the reflected models should replace existing models or not.
    # @return [DataMapper::Model Array] the reflected models.
    # 
    def self.reflect(repository, overwrite=false)
      adapter = DataMapper.repository(repository).adapter
      models = Array.new
      adapter.get_storage_names.each do |model|
        description = Hash.new
        attributes = adapter.get_properties(model)
        description.update( {'id' => model } )
        description.update( {'properties' => {}} )
        attributes.each do |attribute|
          description['properties'].update( { attribute[:name] =>  attribute } )
        end
        desc = make_model_string(description, repository)
        models << Object.class_eval(desc).model
      end
      models
    end

    ##
    # Main reflection method reflects models out of a repository.
    # @param [Slug] repository is the key to the repository that will be reflected.
    # @param [Constant] namespace is the namespace into which the reflected models will be added
    # @param [Boolean] overwrite indicates the reflected models should replace existing models or not.
    # @return [DataMapper::Model Array] the reflected models.
    #
    def self.reflect2(repository, namespace=nil, overwrite=false)
      adapter = DataMapper.repository(repository).adapter
      models = Array.new
      adapter.get_storage_names.each do |model|
        unamed_class = DataMapper::Model.new do 
            storage_names[repository] = model.to_s;
            self.class_eval("def self.default_repository_name; :#{repository}; end")
        end
        
        context = namespace.nil? ? Object : namespace
        # If the first part of the model name matches the context, we need to strip it
        ctxtname = adapter.resource_naming_convention.call(namespace.to_s)
        match = /(#{ctxtname})?(^|_|\/)(.*)/.match(model)
        new_model_name = Extlib::Inflection.classify(match[3])
        puts "CTXT: #{ctxtname} Match: #{match[3]} MN: #{new_model_name}"
        new_model = context.const_set(new_model_name, unamed_class)
        attributes = adapter.get_properties(model)
        attributes.each do |attribute|
          attribute.delete_if { |k,v| v.nil? }
          new_model.property(attribute.delete(:name).to_sym, attribute.delete(:type), attribute)
        end
        models << new_model
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