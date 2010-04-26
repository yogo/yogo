module DataMapper
  module Model

    ##
    # Used to return the correct subset of Objects for the page given 
    #
    # @example
    #   paginate
    #
    # @param [Hash] options 
    # @option options [Integer] :page 
    #   What page to get, default 1
    # @option options [Integer] :per_page 
    #  How many items per page, default 5
    #
    # @return [Array] subset of objects in the datastore for pagination.
    #
    # @author Yogo Team
    #
    # @api public
    def paginate(options = {})
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || 5

      options.merge!({
        :limit => per_page,
        :offset => (page.to_i - 1) * per_page
      })

      all(options)
    end

    ##
    # Calculate the number of pages required given per_page
    #
    # @example
    #  page_count({:page => 1, :per_page => 10})
    #
    # @param [Hash] options 
    # @option options [Integer] :per_page 
    #  How many items per page, default 5
    #
    # @return [Array] how many pages there are in the database
    #
    # @author Yogo Team
    #
    # @api public
    def page_count(options = {})
      per_page = options.delete(:per_page) || 5

      (all(options).count.to_f / per_page).ceil
    end
  end
  
  class Collection
    ##
    # Returns appropriate number of objects based on page number and number per page
    #
    # @example
    #   paginate({:page => 1, :per_page => 10})
    #
    # @param [Hash] options
    # @option options [integer] :page
    #   current page
    # @option options [integer] :per_page
    #   number of items on page
    #
    # @return [Array] a subset of objects in the datastore for pagination
    # 
    # @author Yogo Team
    #
    # @api public
    def paginate(options = {})
      page = options.delete(:page) || 1
      per_page = options.delete(:per_page) || 5

      options.merge!({
        :limit => per_page,
        :offset => (page.to_i - 1) * per_page
      })

      all(options)
    end
    ##
    # Returns number of pages in database, based on per_page
    #
    # @example
    #   page_count({:per_page => 10})
    #
    # @param [Hash] options
    # @option options [integer] :per_page
    #   number of items on page
    #
    # @return [Array] how many pages there are in the database
    #
    # @author Yogo Team
    #
    # @api public
    def page_count(options = {})
      per_page = options.delete(:per_page) || 5

      (all(options).count.to_f / per_page).ceil
    end
  end
end