module DataMapper
  class Property
    class YogoImage < String
      length 2000

      def primitive?(value)
        value.kind_of?(::String)
      end

    end
  end # class Property
  
  module YogoImageAdapterExtensions
    module PersevereAdapter
      extend Chainable
      
      chainable do
        # @api private
        def type_map
          @yogo_file_type_map ||= {
            DataMapper::Property::YogoImage => { :primitive => 'string', :yogo_image => 'true'}
          }.merge(super).freeze
        end
      end
      
      chainable do
        # @api private
        def get_type(dm_type)
          if dm_type['type'].is_a?(String) && dm_type['type'].gsub(/\(\d*\)/, '') == 'string' && dm_type.has_key?('yogo_image')
            return DataMapper::Property::YogoImage
          else
            return super
          end
        end
      end
  
    end
  end
  
  module Adapters
    extendable do
      # @api private
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