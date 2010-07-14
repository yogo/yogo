# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: factory.rb
# This Factory builds DataMapper models 
#
module DataMapper
  class Factory
    
    # There is one factory to rule them all, and in the data bind them.
    include Singleton
    
    # Create a datamapper model based on the description passed in
    #
    # @example an example should go here!
    #
    # @param [Hash] desc
    # @option desc [Array] :modules array of modules the class will be namespaced into by the order they are in the array
    # @option desc [String or Symbol] :name The name of the class in camel case format.
    # @option desc [Hash] :properties a hash of properties
    # 
    # @option properties [Hash] pname 
    #  This is the actual property name and is the hash-key
    # @option pname [String] :ptype 
    #  The datatype of the property   
    # @option pname [Boolean] :required  
    #  If the property can be null or not
    # @option pname [Integer] :position 
    #  the position/order of the property when stored and displayed
    # 
    # @param [String] repository_name 
    #  The name of the repository to associate the DataMapper Model with
    # 
    # @param [Hash] options
    # @option options [String] :attribute_prefix
    #
    # @return [Class] The class the factory created
    # 
    #
    # @todo Implement support for relationships/associations
    #   This ill need to handle associations somehow :associations => {} associations this class has with other classes.
    #
    # @author Yogo Team
    #
    # @api public
    def build(desc, repository_name = :default, options = {})
      module_names = desc[:modules] || []
      class_name   = desc[:name]
      properties   = desc[:properties]
      full_name    = (module_names + [class_name]).join('::')
      attribute_prefix = options[:attribute_prefix]
      
      # Create the scoping for the class, if it doesn't already exist.
      namespace = if module_names.any?
        Object.make_module(module_names.join('::'))
      else
        Object
      end

      if namespace.const_defined?(class_name) # && options[:overwrite] == true
        cur_class = namespace.const_get(class_name)
        DataMapper::Model.descendants.delete(cur_class)
        namespace.send(:remove_const, class_name.to_sym)
      end

      # Define our anonymous class, anonymously.
      anon_class = DataMapper::Model.new do 
        self.class_eval("def self.default_repository_name; :#{repository_name}; end")
        properties.each_pair do |property, opts|
          if opts.is_a?(Hash)
            opts[:type] = :'DataMapper::Property::Serial' if opts[:type].to_s == 'Serial'
            opts[:prefix] = attribute_prefix unless property.to_sym == :yogo_id
            property( property.to_sym, eval(opts[:type].to_s), opts.reject{|k,v| k == :type })
          else
            opts = :'DataMapper::Property::Serial' if opts.to_s == 'Serial'
            options = property.to_sym == :yogo_id ? {} : { :prefix => attribute_prefix }
            property( property.to_sym, eval(opts.to_s), options)
          end
        end
      end

      # Give the class a name.
      named_class = namespace.const_set(class_name, anon_class)
      
      named_class.send(:include, options[:modules]) if options.has_key?(:modules)
      named_class.properties.sort!
      return named_class
    end

    
  end# class Factory
end # module DataMapper