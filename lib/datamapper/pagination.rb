module Yogo
  module DataMapper
    module Model
      module Pagination

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
          current_page = options.delete(:page) || 1
          per_page = options.delete(:per_page) || 30

          total_entries = all(options).count()

          options.merge!({
            :limit => per_page,
            :offset => (current_page.to_i - 1) * per_page
          })

          paginated_collection = all(options)
          paginated_collection.instance_variable_set("@current_page", current_page.to_i)
          paginated_collection.instance_variable_set("@per_page", per_page.to_i)
          paginated_collection.total_entries = total_entries
          
          return paginated_collection
        end

      end # Pagination
    end # Model

    module Collection
      module Pagination
        attr_reader :current_page, :per_page, :total_entries, :total_pages

        # Helper method that is true when someone tries to fetch a page with a
        # larger number than the last page. Can be used in combination with flashes
        # and redirecting.
        def out_of_bounds?
          current_page > total_pages
        end

        # Current offset of the paginated collection. If we're on the first page,
        # it is always 0. If we're on the 2nd page and there are 30 entries per page,
        # the offset is 30. This property is useful if you want to render ordinals
        # besides your records: simply start with offset + 1.
        def offset
          (current_page - 1) * per_page
        end

        # current_page - 1 or nil if there is no previous page
        def previous_page
          current_page > 1 ? (current_page - 1) : nil
        end

        # current_page + 1 or nil if there is no next page
        def next_page
          current_page < total_pages ? (current_page + 1) : nil
        end

        def total_entries=(number)
          @total_entries = number.to_i
          @total_pages   = (@total_entries / per_page.to_f).ceil
        end

      end
    end
  end # DataMapper
end # Yogo

DataMapper::Model.append_extensions(Yogo::DataMapper::Model::Pagination)
DataMapper::Collection.send(:include, Yogo::DataMapper::Collection::Pagination)