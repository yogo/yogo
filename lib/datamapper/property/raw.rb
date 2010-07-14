module DataMapper
  class Property
    class Raw < String
      length 2000
      
      def primitive?(value)
        value.kind_of?(::String)
      end
      
    end
    
  end # class Property
end # module DataMapper