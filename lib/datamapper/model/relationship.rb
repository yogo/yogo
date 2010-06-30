module DataMapper
  module Model
    module CustomRelationship
      Model.append_extensions self

      ##
      # Overwriting the 'has' method for models
      # 
      # @example
      #   has(n, bozons)
      # 
      # @return [Relationship]
      #
      # @api public
      # 
      # @author Robbie Lamb
      def has(cardinality, name, *args)
        # Collect options from splat or initialize empty hash if nothing
        options = args.pop
        options = {} unless options.kind_of?(Hash)
        
        # Extract the model from paramaeters if it exists
        # or use the hash parameter if it doesn't exist.
        model = extract_model(args)
        model ||= options.delete(:model)
        model ||= name.to_s.singularize.capitalize
        
        # must munge the name.
        prefix = options[:prefix]
        
        name = "#{prefix}#{name.to_s.sub(prefix.to_s, '')}".to_sym
        
        args.push(options)
        
        super(cardinality, name, model, *args)
      end
      
      ##
      # Overwriting the 'belongs_to' method for models
      # 
      # @example
      #   belongs_to(bozons)
      # 
      # @return [Relationship]
      # 
      # @api public
      # 
      # @author Robbie Lamb
      def belongs_to(name, *args)
        # Collect options from splat or initialize empty hash if nothing
        options = args.pop
        options = {} unless options.kind_of?(Hash)

        # Extract the model from paramaeters if it exists
        # or use the hash parameter if it doesn't exist.
        model = extract_model(args)
        model ||= options.delete(:model)
        model ||= name.to_s.singularize.capitalize
        
        # must munge the name.
        prefix = options[:prefix]

        name = "#{prefix}#{name.to_s.sub(prefix.to_s, '')}".to_sym

        args.push(options)

        super(name, model, *args)
      end
      
    end
  end
end