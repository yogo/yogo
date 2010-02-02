module DataMapper
  module Model
    # Searches over all of the fields with a like.
    def search(value, options = {})
      # Datamapper doesn't perform an actual query until the query object is looked at.
      # So we create a bunch individual query objects, and 'or' them together.
      # only 1 query is performed in the end.
      queries = []
      properties.each do |prop|
        if prop.type == String
          queries << all( options.merge(prop.name.like => "%#{value}%") )
        end
      end
      
      query = queries.first
      queries[1..-1].each{|q| query = query | q }
      
      return query
    end
  end
  
  class Collection
    # Searches over all of the fields with a like.
    def search(value, options = {})
      # Datamapper doesn't perform an actual query until the query object is looked at.
      # So we create a bunch individual query objects, and 'or' them together.
      # only 1 query is performed in the end.
      queries = []
      properties.each do |prop|
        if prop.type == String
          queries << all( options.merge(prop.name.like => "%#{value}%") )
        end
      end
      
      query = queries.first
      queries[1..-1].each{|q| query = query | q }
      
      return query
    end
  end
end