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
              result[:name] == 'yogo_id'
              result[:field] == 'id'
            end
          end
          puts 'my get_props called'
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
        puts 'Calling my duck punching'
        super
        puts "blah: #{const_name}"
        if Yogo::Reflection.const_defined?(const_name)
          puts 'including my duck punch'
          adapter = const_get(const_name)
          adapter.send(:include, DataMapper::YogoFileAdapterExtensions.const_get(const_name))
        end
      end
    end
  end
end