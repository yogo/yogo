# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: group.rb
# Groups for projects and users. A Project will have groups, and users will belong to groups

class Group
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean, :default => false
  
  property :permissions, String, :default => '', :length => 200 #, :accessor => :private
  
  has n, :users, :through => Resource
  belongs_to :project, :required => false
  
  SYSTEM_ACTIONS = [ :create_projects ]
  PROJECT_ACTIONS = [ :edit_project, :edit_model_descriptions, :edit_model_data, :delete_model_data ]
  AVAILABLE_ACTIONS = SYSTEM_ACTIONS + PROJECT_ACTIONS
  

  ##
  # Adds a action to be permitted to the group
  # 
  # @example
  #   group.add_permission(:edit_project)
  # 
  # @param [Symbol or String] action
  #   The action to add to the permission list for this group
  # 
  # @return [Array] not useful
  # 
  # @raise [NonExistantPermissionError] If the given action isn't valid
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # 
  # @api public
  def add_permission(action)
    setup_permissions if @permissions_array.nil?
    action = action.to_sym
    
    check_action(action)
      
    @permissions_array << action unless @permissions_array.include?(action)
  end

  ##
  # Checks to see if the group has permission for an action
  # 
  # @example
  #   group.has_permission?(:edit_project)
  # 
  # @param [Symbol or String] action
  #   The action to check permission for
  # 
  # @return [Boolean]
  #   True or False depending if the group has permission or not
  # 
  # @raise [NonExistantPermissionError] If the given action isn't valid
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # 
  # @api public
  def have_permission?(action)
    setup_permissions if @permissions_array.nil?
    action = action.to_sym
    
    check_action(action)
    
    @permissions_array.include?(action)
  end
  
  alias :has_permission? :have_permission?
  
  ##
  # Removes a permission from a group
  # 
  # @example
  #   group.remove_permission?(:edit_project)
  # 
  # @param [Symbol or String] action
  #   The action to remove permission for
  # 
  # @return [Array]
  #   Not useful
  # 
  # @raise [NonExistantPermissionError] If the given action isn't valid
  # 
  # @author Robbie Lamb robbie.lamb@gmail.com
  # 
  # @api public
  def remove_permission(action)
    setup_permissions if @permissions_array.nil?
    check_action(action)
    action = action.to_sym
    @permissions_array.delete(action)
  end
  
  # def permissions
  #   return [] if @permissions_array.nil?
  #   @permissions_array.dup
  # end
  
  private

  ##
  # setsups permissions array
  # @return [Array] not useful 
  # @api private
  def setup_permissions
    @permissions_array = attribute_get(:permissions).split(' ').map{|p| p.to_sym }
  end

  ##
  # Puts permissions into a string
  # @return [Array] not useful 
  # @api private
  def permissions_to_string
    attribute_set(:permissions, @permissions_array.join(' '))
  end
  
  ##
  # To raise and EXCEPTION
  # @return [nil] not useful 
  # @raise [NonExistantPermissionError]
  # @api private
  def check_action(action)
    raise NonExistantPermissionError, "#{action} is not a valid permission" unless
      AVAILABLE_ACTIONS.include?(action)
  end
  
  public 
  after :add_permission, :permissions_to_string
  after :remove_permission, :permissions_to_string
  
end
