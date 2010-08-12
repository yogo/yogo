require 'yogo/project'

module Yogo
  class Project
    extend Permission
    include Facet::DataMapper::Resource
    
    property :is_private,      Boolean, :required => true, :default => false
    
    has n, :memberships
    has n, :roles, :through => :memberships
    has n, :users, :through => :memberships
    
    def self.extended_permissions
      collection_perms = ['collection', 'item'].map do |elem|
        self.basic_permissions.map{|p| "#{p}_#{elem}".to_sym }
      end
      
      # collection_perms = [ :create_collection, :retrieve_collection, :update_collection, :delete_collection, :create_data, :retrieve_data, :update_data, :delete_data ]
      [:manage_users, collection_perms, super].flatten
    end
    
    ##
    # @return [Boolean]
    # @api public
    def allow_access?(permission, user)
      # we want all admins to access this resource
      return true if user.admin?
      user.roles(:project => self).any?{|r| r.has_permission?(permission) }
    end
    
  end
end
