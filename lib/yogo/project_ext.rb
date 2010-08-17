require 'yogo/project'

module Yogo
  class Project
    # extend Permission
    include Facet::DataMapper::Resource
    
    property :is_private,      Boolean, :required => true, :default => false
    
    has n, :memberships, :parent_key => [:id], :child_key => [:project_id], :model => 'Membership'
    has n, :roles, :through => :memberships
    has n, :users, :through => :memberships
    
    after :create, :give_current_user_membership
    before :destroy, :destroy_cleanup
    
    # def self.extended_permissions
    #   collection_perms = ['collection', 'item'].map do |elem|
    #     self.basic_permissions.map{|p| "#{p}_#{elem}".to_sym }
    #   end
    #   
    #   # collection_perms = [ :create_collection, :retrieve_collection, :update_collection, :delete_collection, :create_data, :retrieve_data, :update_data, :delete_data ]
    #   [:manage_users, collection_perms, super].flatten
    # end
    
    def self.permissions_for(user)
      (super << "#{permission_base_name}$retrieve").uniq
    end
    
    ##
    # 
    def permissions_for(user)
      return ["#{permission_base_name}$retrieve"] if user.nil?
      super + user.memberships(:project_id => self.id).roles.map{|r| r.actions }.flatten.uniq
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
