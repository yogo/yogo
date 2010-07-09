module DataMapper
  module Types
    
    class Raw < DataMapper::Type
      primitive String
      length 2000
      # load
      # @return [String]
      # @api private
      def self.load(value, property)
        value
      end
      
      # dump
      # @return [String]
      # @api private
      def self.dump(value, property)
        value
      end
      
      # typecast
      # 
      # @return [String]
      # @api private
      def self.typecast(value, property)
        value
      end
    end
    
  end # module Types
end # module Crux