class Object
  def is_facet?
    false
  end
end

module Facet
  
  # wraps and restricts access to an object
  class Proxy < ActiveSupport::BasicObject
    def initialize(target, permission_source, root_target = nil)
      @target = target
      @permission_source = permission_source
      @root_target = root_target
    end
    
    def can_invoke(method)
      (permitted_methods + @target.unsecured_methods).include?(method.to_sym)
    end
    
    alias can_invoke? can_invoke
    
    def permitted_methods
      ::DataMapper.repository(:default) {
        permissions = @target.permissions_for(@permission_source)
        permissions = permissions | @root_target.permissions_for(@permission_source) unless @root_target.nil?
        @target.methods_permitted_for(*permissions)
     }
    end
    
    def permitted_actions
     ::DataMapper.repository(:default) {
       permissions = @target.permissions_for(@permission_source)
       permissions = permissions | @root_target.permissions_for(@permission_source) unless @root_target.nil?
       @target.actions_permitted_for(*permissions)
      }
    end
    
    def method_missing(method, *args, &block)
      self.send(method, *args, &block)
    end
    
    def send(method, *args, &block)
      # ::Rails.logger.debug("Can #{@permission_source} Invoke? #{method} #{can_invoke method}")
      raise NoMethodError, "undefined method #{method} for #{@target}" unless @target.respond_to?(method) || permitted_methods.include?(method.to_sym)
      if(can_invoke method)
        result = @target.__send__(method, *args, &block)
        # TODO: Extract out this DataMapper specific code
        if (result.kind_of?(::DataMapper::Collection) && result.model.respond_to?(:access_as)) ||
           (result.kind_of?(::DataMapper::Resource)   && result.respond_to?(:access_as))
          # Reuse the current root_target, or use the current target if it's an instance, not a class
          return result.access_as(@permission_source, next_root_target)
        else
          return result
        end
      else
        # logger.debug { "Access denied to method #{method}" }
        ::Rails.logger.info("Access denied to method #{method} on #{@target}")
        raise Facet::PermissionException::Denied, "#{method} on #{@target} is not allowed"
      end
    end
    
    def each(&block)
      @target.__send__(:each) do |i|
        if !i.is_facet? && i.respond_to?(:access_as)
          # ::Rails.logger.debug("This should do something")
          yield i.access_as(@permission_source, next_root_target)
        else
          # ::Rails.logger.debug("This is calling my each")
          yield i
        end
      end
    end
    
    def is_facet?
      true
    end
    
    def permission_source
      @permission_source
    end
    
    def root_target
      @root_target
    end
    
    # Reuse the current root_target, or use the current target if it's an instance, not a class
    def next_root_target
      if !@root_target.nil?
        return @root_target
      elsif @target.kind_of?(::DataMapper::Resource )
        @target
      else
        return nil
      end
    end
    
    def can_create?
      permitted_actions.include?(:create)
    end
    
    def can_retrieve?
      permitted_actions.include?(:retrieve)
    end
    alias can_read? can_retrieve?
    
    def can_update?
      permitted_actions.include?(:update)
    end
    
    def can_destroy?
      permitted_actions.include?(:destroy)
    end
    alias can_delete? can_destroy?
    
  end
  
  class PermissionException < Exception
    class Denied < PermissionException
    end
  end
  
  
  module SecurityWrapper
    def access_as(access = nil, root_target = nil)
      # When running in local only, bypass all access by returning self
      if ::DataMapper.repository(:default) { Setting[:local_only] }
        self
      else
        Facet::Proxy.new(self, access, root_target)
      end
    end
    
    alias as_facet access_as
  end
  
  # mixin for objects that will be wrapped
  module SecureMethods
    include SecurityWrapper
    
    def secured_methods
      []
    end
    
    def unsecured_methods
      # [:class, :inspect, :methods, :send, :secured_methods, :unsecured_methods] 
      [ :debugger, :empty? ] - secured_methods
    end
    
  end
  
  module ModelSecureMethods
    include SecureMethods
    
    def secured_methods
      super + [:new, :create, :all, :first, :last, :get, :count]
    end
    
    def secured_instance_methods
      [:attributes, :attributes=, :save, :destroy]
    end
    
    def unsecured_instance_methods
      # TODO: Evaluate what instance methods should be unsecured
      [:debugger, :class, :empty?, :is_a?, :nil?, :respond_to?, :to_param, :valid?]  
      # self.instance_methods.map{ |k| k.to_sym }) - secured_instance_methods
      # self.instance_methods - secured_instance_methods
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
       
    def actions_permitted_for(*perms)
      actions = []
      perms.each do |pstring|
        name, perm = pstring.split('$')
        next unless permission_base_name == name
        actions << perm.to_sym
      end
      actions.flatten.uniq
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
        :retrieve => [:all, :get, :first, :last, :count, :map, :each, :&, :|] + 
          relationships.keys.map{|m| m.to_s.to_sym } +
          self.methods.map{|m| m.to_sym } - [:update, :destroy, :new, :create, :create!],
        :update => [:update],
        :destroy => [:destroy]
      }
    end
        
    def permission_base_name
      self.name.underscore
    end
    
    def permissions_for(target)
      return [] if target.nil?
      target.system_role.actions & self.to_permissions
    end
  end
  
  module ResourcePermissions
    include Permissions
    
    def permissions
      {
        :create => [],
        :retrieve => [:attributes] + self.methods.map{ |k| k.to_sym } - [:attributes=, :save, :update, :save_parents, :save_children, :destroy, :destroy!],
        :update => [:attributes=, :save, :update, :save_parents, :save_children],
        :destroy => [:destroy]
      }
    end
    
    def to_permissions
      self.class.to_permissions
    end
        
    def permission_base_name
      self.class.permission_base_name
    end
    
    def permissions_for(target)
      return [] if target.nil?
      target.system_role.actions & self.to_permissions
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

# Also send this
DataMapper::Collection.send(:include, Facet::SecurityWrapper)

