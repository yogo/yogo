module Rails
  module DataMapper
    class Storage

      if !const_defined?(:Rest)
        class Rest < Storage
          def _create
            # Noop. Can't create a Rest endpoint :)
            true
          end

          def _drop
            # Also Noop. Can't delete a Rest endpoint.
          end

          def create_message
            "[datamapper] db:create is a noop for dm-rest-adapter endpoints"
          end
        end
      end
    end
  end
end
