#This is my factory. Vadka sqweu driver you buddy.
module DataMapper
  class Factory
    # This will look for a hash with certain keys in it. Those keys are:
    # :modules    =>  [], and array of modules the class will be namespaced into by the order they are in the array
    # :name       =>  'ClassName' The name of the class in camel case format.
    # :properties =>  {}, a hash of properties
    # 
    #     Each key in the property hash is the name of the property.
    #     if the key points to a string or symbol, that will be used as the property type.
    #     The property type should be a valid DataMapper property type.
    #
    #     If the key points to a hash, dum, Dum, DUM!? What will happen?!
    #
    #  TODO : Implement support for relationships/associations
    # :associations => {} associations this class has with other classes.
    #
    # This returns a datamapper model. 
    def self.build(desc, repository_name = :default, options = {})
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
          class_definition += "property :#{property}, #{opts[:type]}"
          opts.reject{|k,v| k == :type}.each_pair{|key,value| class_definition += ", :#{key} => #{value}"}
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

    def self.make_model_from_csv(class_name, spec_array)
      scopes = class_name.split('::')
      spec_hash = { :name => scopes[-1], :properties => Hash.new }
      spec_hash[:modules] = scopes[0..-2] unless scopes.length.eql?(1)                  
      spec_array[0].each_index do |idx|
        prop_hash = Hash.new
        pname = spec_array[0][idx].tableize.singular
        ptype = spec_array[1][idx]
        punits = spec_array[2][idx]
        pkey = pname == 'id' ? true : false
        prop_hash = { pname => { :type => ptype, :required => false, :key => pkey } }
        spec_hash[:properties].merge!(prop_hash) 
      end

      self.build(spec_hash, :yogo)
    end
  end
end