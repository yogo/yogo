module Facet
  
  # wraps and restricts access to an object
  class Proxy < ActiveSupport::BasicObject
    def initialize(target, permission_source)
      @target = target
      @permission_source = permission_source
    end
    
    def can_invoke(method)
      (permitted_methods + @target.unsecured_methods).include?(method)
    end
    
    def permitted_methods
      permissions = @permission_source.permissions_for(@target)
      @target.methods_permitted_for(*permissions) 
    end
    
    def method_missing(method, *args, &block)
      if(can_invoke method)
        @target.send(method, *args, &block)
      else
        raise Facet::PermissionException::Denied, "#{method} is not allowed"
      end
    end
  end
  
  class PermissionException < Exception
    class Denied < PermissionException
    end
  end
  
  # mixin for objects that will be wrapped
  # Project.extend
  module SecureMethods
    def secured_methods
      []
    end
    
    def unsecured_methods
      [:inspect, :methods]
    end
    
    def access_as(access)
      Facet::Proxy.new(self, access)
    end
    
  end
  
  module ModelSecureMethods
    include SecureMethods
    
    def secured_methods
      super + [:new, :create, :all, :first, :last, :get]
    end
    
    
    def secured_instance_methods
      [:attributes, :attributes=, :save, :destroy]
    end
    
    def unsecured_instance_methods
      [:valid?]
    end
  end
  
  module ResourceSecureMethods
    include SecureMethods
    
    def secured_methods
      super + self.class.secured_instance_methods
    end
    
    def unsecured_methods
      super + self.class.unsecured_instance_methods
    end
  end
  
  module Permissions
    def permissions
      {}
    end
    
    def to_permissions
      permissions.map { |perm, meths| "#{permission_base_name}$#{perm}" }
    end
    
    def methods_permitted_for(*perms)
      methods = []
      perms.each do |pstring|
        name, perm = pstring.split('$')
        next unless permission_base_name == name
        methods += self.permissions[perm.to_sym]
      end
      methods.flatten.uniq
    end
        
    def permission_base_name
      ""
    end
  end
  
  module ModelPermissions
    include Permissions
    
    def permissions
      {
        :create => [:new, :create],
        :retrieve => [:all, :get, :first, :last],
        :update => [:update],
        :destroy => [:destroy]
      }
    end
        
    def permission_base_name
      self.name.underscore
    end
  end
  
  module ResourcePermissions
    include Permissions
    
    def permissions
      {
        :create => [],
        :retrieve => [:attributes],
        :update => [:attributes=, :save, :update],
        :destroy => [:destroy]
      }
    end
    
    def to_permissions
      self.class.to_permissions
    end
        
    def permission_base_name
      self.class.permission_base_name
    end
  end
  
  module DataMapper
    module Resource
      def self.included(base)
        base.class_eval do
          extend Facet::ModelSecureMethods
          extend Facet::ModelPermissions
          include Facet::ResourceSecureMethods
          include Facet::ResourcePermissions
        end
      end
    end # Resource
  end # DataMapper
end # Facet