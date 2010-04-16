module DataMapper
  module Reflection
    module PersevereAdapter
      extend Chainable

      ##
      # Convert the JSON Schema type into a DataMapper type
      #
      # @todo This should be verified to identify all mysql primitive types
      #       and that they map to the correct DataMapper/Ruby types.
      #
      # @param [String] db_type type specified by the database
      # @param [String] optional format format specification for string attributes
      # @return [Type] a DataMapper or Ruby type object.
      #
      chainable do
        def get_type(db_type)
          type = db_type['type']
          format = db_type['format']

          case type
          when Hash        then DataMapper::Types::JsonReference
          when 'array'     then DataMapper::Types::JsonReferenceCollection
          when 'serial'    then DataMapper::Types::Serial
          when 'integer'   then Integer
          # when 'number'    then BigDecimal
          when 'number'    then Float
          when 'boolean'   then DataMapper::Types::Boolean
          when 'string'    then
            case format
              when nil         then DataMapper::Types::Text
              when 'date-time' then DateTime
              when 'date'      then Date
              when 'time'      then Time
            end
          end
        end
      end
      ##
      # Get the list of schema names
      #
      # @return [String Array] the names of the schemas in the server.
      #
      def get_storage_names
        @schemas = self.get_schema
        @schemas.map { |schema| schema['id'].gsub('/', '__') }
      end

      ##
      # Get the attribute specifications for a specific schema
      #
      # @todo Consider returning actual DataMapper::Properties from this.
      #       It would probably require passing in a Model Object.
      #
      # @param [String] table the name of the schema to get attribute specifications for
      # @return [Array] of hashes the column specs are returned in a hash keyed by `:name`, `:field`, `:type`, `:required`, `:default`, `:key`
      #
      chainable do
        def get_properties(table)
          results = Array.new
          schema = self.get_schema(table.gsub('__', '/'))[0]
          schema['properties'].each_pair do |key, value|
            type = get_type(value)
            property = {:name => key, :type => type }
            property.merge!({ :required => !value.delete('optional'),
                              :key => value.has_key?('index') && value.delete('index') }) unless property[:type] == DataMapper::Types::Serial
                              
            if type.kind_of?(DataMapper::Types::JsonReference)
              property.merge!( {:reference => derive_relationship_model(value[:type]["$ref"])} )
            end
            
            if type.kind_of?(DataMapper::Types::JsonReferenceCollection)
              property.merge!( {:reference => derive_relationship_model(value[:items]["$ref"])} )
            end
            
            value.delete('type')
            value.delete('format')
            value.delete('unique')
            value.delete('index')
            value.keys.each { |key| value[key.to_sym] = value[key]; value.delete(key) }
            property.merge!(value)
            results << property
          end
          return results
        end
      end

      private
      
      # Turns 'class_path/class' into 'ClassPath::Class
      def derive_relationship_model(input)
        input.match(/(Class)?\/([a-z\-\/\_]+)$/)[-1].split('/').map{|i| ExtLib::Inflection.classify(i) }.join("::")
      end
      
    end # module PersevereAdapter
  end # module Reflection
end # module DataMapper
