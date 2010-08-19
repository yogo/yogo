require 'yogo/project'
require 'yogo/datamapper/storage_manager'

module Yogo
  class Project
    # extend Permission
    include Facet::DataMapper::Resource
    
    extend Permission
    include Yogo::DataMapper::StorageManager

    property :is_private,      Boolean, :required => true, :default => false
    
    has n, :memberships, :parent_key => [:id], :child_key => [:project_id], :model => 'Membership'
    has n, :roles, :through => :memberships
    has n, :users, :through => :memberships
    
    after :create, :give_current_user_membership
    before :destroy, :destroy_cleanup
    
    def self.permissions_for(user)
      # By default, all users can retrieve projects
      (super << "#{permission_base_name}$retrieve").uniq
    end

    def managed_storage_name
      ActiveSupport::Inflector.tableize(id.to_s)
    end
    
    ##
    # 
    def permissions_for(user)
      @_permissions_for ||= {}
      @_permissions_for[user] ||= begin
        base_permission = []
        base_permission << "#{permission_base_name}$retrieve" unless self.is_private?
        return base_permission if user.nil?
        (super + base_permission + user.memberships(:project_id => self.id).roles.map{|r| r.actions }).flatten.uniq
      end
    end
    
    private
    
    def destroy_cleanup
      memberships.destroy
    end
    
    def give_current_user_membership
      unless User.current.nil?
        Membership.create(:user => User.current, :project => self, :role => Role.first(:position => 1))
      end
    end

  end
end
