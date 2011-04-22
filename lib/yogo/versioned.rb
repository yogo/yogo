require 'dm-core'
require 'dm-is-versioned'

module Yogo
  module Versioned
    def yogo_versioned
      # Add properties required for versioning
      property :updated_at,          ::DataMapper::Property::DateTime
      property :updated_by,          ::DataMapper::Property::Integer
      property :updated_comment,     ::DataMapper::Property::Text

      # Register before save hooks
      before(:save) do
        self.updated_at = Time.now
        self.updated_by = User.current.id
        self.updated_comment = "Edited at #{self.updated_at} by #{User.current.first_name} #{User.current.last_name} [#{User.current.login}]"
      end

      # Register with dm-is-versioned
      is_versioned :on => [:updated_at]
    end

    module DataMapper
      module Resource
        def self.included(base)
          base.class_eval do
            extend Yogo::Versioned
            #include Facet::ResourceSecureMethods
          end
        end
      end # Resource
    end # DataMapper
  end # Versioned
end # Yogo
