
module Yogo
  ##
  # A module that contains the functionality to reflect
  # 
  # the properties of a Yogo model from the data back-end
  #
  # @author Robbie Lamb
  #
  module Reflection
    ##
    # A module specific for a Persevere back-end reflection
    #
    # reflects the Yogo model from Persevere
    #
    # @author Robbie Lamb
    #
    # @api private
    module PersevereAdapter
      extend DataMapper::Chainable

      chainable do
        ##
        # Gets the properites of a Perevere table
        #
        # @params [String] table
        #   The name of a table in the Persevere data-store
        #
        # @return [Array<Hash>] An array of the tables fields with each element 
        # as a hash of :field and :name where :name has been deprefixed of ^yogo___
        #
        # @author Robbie Lamb
        #
        # @api private
        #
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
      ##
      # Checks if a constant was added
      #
      # @param [String] const_name
      #  The name of the constant to check
      #
      # @return [Boolean] True is the constant was added and false if it was not
      # 
      # @author Robbie Lamb
      #
      # FIXME @api  
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