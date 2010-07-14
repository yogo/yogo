module DataMapper
  class Property
    class YogoFile < String
      length 2000

      def custom?
        true
      end

      def primitive?(value)
        # value.kind_of?(::String)
        value.respond_to?(:filename) || value.kind_of?(::String)
      end
      
      def load(value)
        if value.respond_to?(:filename)
          value.filename
        else
          value.to_s
        end
      end
      
      def dump(value)
        load(value)
      end
      
      def typecast_to_primitive(value)
        load(value)
      end

    end
  end # class Property

  module YogoFileAdapterExtensions
    module PersevereAdapter
      extend Chainable
      
      chainable do
        def type_map
          @yogo_file_type_map ||= {
            DataMapper::Property::YogoFile => { :primitive => 'string', :yogo_file => 'true'}
          }.merge(super).freeze
        end
      end
      
      chainable do
        def get_type(dm_type)
          if  dm_type['type'].is_a?(String) && dm_type['type'].gsub(/\(\d*\)/, '') == 'string' && dm_type.has_key?('yogo_file')
            return DataMapper::Property::YogoFile
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