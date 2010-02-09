module DataMapper
  module Types
    class YogoFile < DataMapper::Type
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
  end
  
  module Adapters
    class PersevereAdapter
      alias old_type_map type_map
      def type_map
        @yogo_file_type_map ||= {
          DataMapper::Types::YogoFile => { :primitive => 'string', :yogo_file => 'true'}
        }.merge(old_type_map).freeze
      end
    end
  end

  module Reflection
    module PersevereAdapter
      alias old_get_type get_type
      def get_type(dm_type)
        if dm_type['type'].gsub(/\(\d*\)/, '') == 'string' && dm_type.has_key?('yogo_file')
          DataMapper::Types::YogoFile
        else
          return old_get_type(dm_type)
        end
      end
    end
  end
end