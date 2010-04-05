module DataMapper
  module Types
    
    class YogoFile < DataMapper::Type
      primitive String
      length    2000
      
      # @api private
      def self.load(value, property)
        value.to_s
      end
      
      # @api private
      def self.dump(value, property)
        value.to_s
      end
      
      # @api private
      def self.typecast(value, property)
        value.to_s
      end
    end
    
  end # module Types
  
  module YogoFileAdapterExtensions
    module PersevereAdapter
      extend Chainable
      
      chainable do
        def type_map
          @yogo_file_type_map ||= {
            DataMapper::Types::YogoFile => { :primitive => 'string', :yogo_file => 'true'}
          }.merge(super).freeze
        end
      end
      
      chainable do
        def get_type(dm_type)
          if dm_type['type'].gsub(/\(\d*\)/, '') == 'string' && dm_type.has_key?('yogo_file')
            return DataMapper::Types::YogoFile
          else
            return super
          end
        end
      end
  
    end
  end
  
  module Adapters
    extendable do
      def const_added(const_name)
        super 
        if DataMapper::YogoFileAdapterExtensions.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::YogoFileAdapterExtensions.const_get(const_name))
        end
      end
    end
  end # module Adapter
end # module DataMapper