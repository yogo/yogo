module DataMapper
  module Types
    
    class YogoImage < DataMapper::Type
      primitive String
      length    2000
      
      def self.load(value, property)
        value.to_s
      end
      
      def self.dump(value, property)
        value.to_s
      end
      
      def self.typecast(value, property)
        value.to_s
      end
    end
    
  end # module Types
  
  module YogoImageAdapterExtensions
    module PersevereAdapter
      extend Chainable
      
      chainable do
        def type_map
          @yogo_file_type_map ||= {
            DataMapper::Types::YogoImage => { :primitive => 'string', :yogo_image => 'true'}
          }.merge(super).freeze
        end
      end
      
      chainable do
        def get_type(dm_type)
          if dm_type['type'].gsub(/\(\d*\)/, '') == 'string' && dm_type.has_key?('yogo_image')
            return DataMapper::Types::YogoImage
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
        if DataMapper::YogoImageAdapterExtensions.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::YogoImageAdapterExtensions.const_get(const_name))
        end
      end
    end
  end # module Adapter
end # module DataMapper