
# # Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: Role.rb
# Roles for projects and users. A Project will have Roles, and users will belong to Roles

class Role
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :admin, Boolean, :default => false
  property :description, String
  property :permissions, Yaml, :default => [].to_yaml

  has n, :users, :through => Resource
  belongs_to :project, :required => false


  SYSTEM_ACTIONS = [ :create_projects ]
  PROJECT_ACTIONS = [ :edit_project, :delete_project, :edit_model_descriptions,  :edit_model_data, :delete_model_data, :view_project ]
  AVAILABLE_ACTIONS = SYSTEM_ACTIONS + PROJECT_ACTIONS

  def permission_sources
    [Project]
  end

  def available_permissions
    permission_sources.map {|ps| ps.to_permissions}.flatten
  end

  def available_permissions_by_source
    source_hash = Hash.new
    permission_sources.each { |ps| source_hash[ps.name] = ps.to_permissions }
    source_hash
  end

  ##
  # Compatability method for rails' route generation helpers
  #
  # @example
  #   @project.to_param # returns the ID as a string
  #
  # @return [String] the object id as url param
  #
  # @author Yogo Team
  #
  # @api public
  def to_param
    self.id.to_s
  end

  ##
  # Adds a action to be permitted to the Role
  #
  # @example
  #   role.add_permission(:edit_project)
  #
  # @param [Symbol or String] action
  #   The action to add to the permission list for this Role
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
  # Checks to see if the Role has permission for an action
  #
  # @example
  #   role.has_permission?(:edit_project)
  #
  # @param [Symbol or String] action
  #   The action to check permission for
  #
  # @return [Boolean]
  #   True or False depending if the Role has permission or not
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

  ##
  # An alias from have_permission?
  #
  # @example
  #   role.has_permission?(:edit_project)
  #
  # @param [Symbol or String] action
  #   The action to check permission for
  #
  # @return [Boolean]
  #   True or False depending if the Role has permission or not
  #
  # @raise [NonExistantPermissionError] If the given action isn't valid
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @api public
  alias :has_permission? :have_permission?

  ##
  # Removes a permission from a Role
  #
  # @example
  #   role.remove_permission?(:edit_project)
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
