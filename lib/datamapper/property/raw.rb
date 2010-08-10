module DataMapper
  class Property
    class Raw < String
      length 2000
      
      ##
      # The kind of primitive for this class
      # 
      # @example
      #   primitvie?
      # 
      # @return [Boolean]
      # 
      # @author lamb
      # @api semipublic
      def primitive?(value)
        value.kind_of?(::String)
      end
      
    end
    
  end # class Property
end # module DataMapper