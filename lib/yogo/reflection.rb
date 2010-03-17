puts 'Loading file'
module Yogo
  module Reflection
    module PersevereAdapter
      extend DataMapper::Chainable

      chainable do
        def get_properties(table)
          results = super
          results.each do |result|
            if result[:name].eql?('id')
              result[:name] = 'yogo_id'
              result[:field] = 'id'
            elsif result[:name].match(/^yogo___/)
              result[:field] == result[:name]
              result[:name] = result[:name].gsub(/^yogo___/, '')
            end
          end
          results
        end
      end
    end
  end

end

module DataMapper
  module Adapters
    extendable do
      def const_added(const_name)
        super
        if Yogo::Reflection.const_defined?(const_name)
          adapter = const_get(const_name)
          adapter.send(:include, Yogo::Reflection.const_get(const_name))
        end
      end
    end
  end
end