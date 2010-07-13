module DataMapper
  module Model

    # Perform a search on a datamapper model
    #
    # @example
    #   DataMapperModel.search("me")
    #
    # @param [String] value 
    #   A string to query on
    # @param [Hash] options 
    #   Any other valid datamapper query option
    #
    # @return [String] Searches over all of the fields with a like
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api public
    def search(value, options = {})
      # Datamapper doesn't perform an actual query until the query object is looked at.
      # So we create a bunch individual query objects, and 'or' them together.
      # only 1 query is performed in the end.
      queries = []
      properties.each do |prop|
        if prop.kind_of?(DataMapper::Property::String) || prop.kind_of?(DataMapper::Property::Text)
          queries << all( options.merge(prop.name.like => "%#{value}%") )
        end
      end

      query = []
      if !queries.empty?
        query = queries.first
        queries[1..-1].each{|q| query = query | q } unless queries.length < 1
      end
      
      return query
    end
  end
  
  class Collection
    
    # Perform a search on a datamapper collection
    #
    # @example
    #   new_collection = Person.all(:name => 'Steve')
    #   new_collection.search("me")
    #
    # @param [String] value 
    #   A string to query on
    # @param [Hash] options 
    #   Any other valid datamapper query option
    #
    # @return [String] Searches over all of the fields with a like
    #
    # @author Robbie Lamb robbie.lamb@gmail.com
    #
    # @api public
    def search(value, options = {})
      # Datamapper doesn't perform an actual query until the query object is looked at.
      # So we create a bunch individual query objects, and 'or' them together.
      # only 1 query is performed in the end.
      queries = []
      properties.each do |prop|
        if prop.type == String || prop.type == DataMapper::Types::Text
          queries << all( options.merge(prop.name.like => "%#{value}%") )
        end
      end
      
      query = queries.first
      queries[1..-1].each{|q| query = query | q }
      
      return query
    end
  end
end