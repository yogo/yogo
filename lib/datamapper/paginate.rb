module DataMapper
  module Model
    # @return [Array] subset of objects in the datastore for pagination.
    # 
    # options :page What page to get, default 1
    #         :per_page How many items per page, default 5
    # FIXME @api private, semipublic, or public
    def paginate(options = {})
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || 5

      options.merge!({
        :limit => per_page,
        :offset => (page.to_i - 1) * per_page
      })

      all(options)
    end

    # @return [Array] how many pages there are in the database.
    # FIXME @api private, semipublic, or public
    def page_count(options = {})
      per_page = options.delete(:per_page) || 5

      (all(options).count.to_f / per_page).ceil
    end
  end
  
  class Collection
    # @return [Array] a subset of objects in the datastore for pagination.
    # 
    # options :page What page to get, default 1
    #         :per_page How many items per page, default 5
    # FIXME @api private, semipublic, or public
    def paginate(options = {})
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || 5

      options.merge!({
        :limit => per_page,
        :offset => (page.to_i - 1) * per_page
      })

      all(options)
    end

    # @return [Array] how many pages there are in the database
    # FIXME @api private, semipublic, or public
    def page_count(options = {})
      per_page = options.delete(:per_page) || 5

      (all(options).count.to_f / per_page).ceil
    end
  end
end