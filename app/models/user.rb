# require 'datamapper/authlogic/compatability'
class User
  include DataMapper::Resource
  # include DataMapper::Authlogic::Compatability
  include SentientUser

  # I'm confused. What is this doing?
  # @example
  #   An example for this is silly (I don't know how to document attr_accessor methods)
  #
  # @return [String] returns the password
  # @api public
  attr_accessor :password, :password_confirmation

  property :id,                 DataMapper::Types::Serial
  property :login,              String, :required => true, :index => true, :unique => true
  property :email,              String, :required => true, :length => 256
  property :first_name,         String, :length => 50
  property :last_name,          String, :length => 50

  # TODO: Make sure a length of 128 is long enough for various encryption algorithms.
  property :crypted_password,     BCryptHash, :required => true,  :length => 128
  property :single_access_token,  String, :required => false, :length => 128, :index => true
  property :login_count,        Integer, :required => true, :default => 0
  property :failed_login_count, Integer, :required => true, :default => 0
  property :last_request_at,    DateTime
  property :last_login_at,      DateTime
  property :current_login_at,   DateTime

  # Long enough for an ipv6 address.
  property :last_login_ip,      String, :length => 36
  property :current_login_ip,   String, :length => 36

  property :created_at, DateTime
  property :created_on, Date

  property :updated_at, DateTime
  property :updated_on, Date

  has n, :roles, :through => Resource

  validates_is_confirmed :password

  ##
  # Finds a user by their login
  #
  # @example
  #   User.find_by_login('lamb') # Returns a user
  #
  # @param [String]
  #   The login to look for.
  #
  # @return [User or nil]
  #   Returns the user if found, or nil if no user was found
  #
  # @author Robbie Lamb
  #
  # @api public
  def self.find_by_login(login)
    self.first(:login => login)
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
  # Returns the user first and last name in one string
  #
  # @example
  #   <%= current_user.name %>
  #
  # @return [String]
  #
  # @author lamb
  #
  # @api public
  def name
    @___name ||= begin
      name = "#{first_name} #{last_name}"
      name = self.login if name.blank?
      name
    end
  end


  ##
  # Password setter
  #
  # @example
  #   current_user.password = 'a password'
  #
  # @param [String] pass
  #   A password to set. Note that password_confirmation also needs to be set.
  #
  # @return [String] the string that was passed in
  #
  # @api public
  def password=(pass)
    @password = pass
    self.crypted_password = pass
  end

  ##
  # Check if the user belongs to a given role
  #
  # @example
  #   current_user.has_role?(:role_name)
  #
  # @param [Symbol or String] role
  # @param [optional, Project] optional project for context
  #
  # @return [Boolean]
  #   True if the user belongs to the role or False if the user doesn't belong to the role
  #
  # @api public
  def has_role?(role_name, project = nil)
    # @_user_role_names ||= Role.all(:project => project, :users => self).collect(&:name)
    @_user_role_names ||= self.roles(:project => project).collect(&:name)
    @_user_role_names.include?(role_name.to_s)
  end

  ##
  # Check to see if the current user can perform the action
  #
  # @example
  #   current_user.has_permission(:destroy_model, @current_project)
  #
  # @param [Symbol or String] action
  #   The action in question
  #
  # @param [optional, Project] optional project for context
  #
  # @return [Boolean]
  #   True if the user has permission or false if the user doesn't have permission
  #
  # @api public
  def has_permission?(action, project = nil)
    self.roles(:project => project).any?{ |role| role.has_permission?(action) }
  end

  ##
  # Check to see if the user belongs to the current project
  #
  # @example
  #  current_user.is_in_project?(a_project)
  #
  # @param [Project] the project in question
  #
  # @return [Boolean]
  #   True if the user is in the project or false if it's not in the project
  #
  # @api public
  def is_in_project?(project)
    self.roles.any?{ |role| role.project.eql?(project) }
  end

  ##
  # Check to see if any of the roles the user is in is an admin role
  #
  # @example
  #   current_user.admin?
  #
  # @return [Boolean] true if the user is an admin, or false otherwise
  #
  # @author lamb
  #
  # @api public
  def admin?
    self.roles.any?{|role| role.admin? }
  end

  ##
  # Alias for admin?
  #
  # @example
  #   current_user.admin
  #
  # @return [Boolean] true if the user is an admin, or false otherwise
  #
  # @author lamb
  #
  # @see admin?
  #
  # @api public
  alias :admin :admin?

  ##
  # Check to see if any of the roles the user is in is an admin role
  #
  # @example
  #   current_user.admin=true
  #
  # @param [Boolean] is_admin True if the user should be an admin, or false
  # @return [nil] Not Interesting
  #
  # @author lamb
  #
  # @api public
  def admin=(is_admin)
    admin_role = Role.first(:project => nil, :admin => true)
    if is_admin == true || is_admin == 1 || is_admin == '1'
      self.roles << admin_role unless self.roles.include?(admin_role)
    else
      self.roles.delete(admin_role) if self.roles.include?(admin_role)
    end
  end

  ##
  # Check to see if any of the roles the user is in can create projects
  #
  # @example
  #   current_user.create_projects?
  #
  # @return [Boolean] true if the user can create projects, or false otherwise
  #
  # @author lamb
  #
  # @api public
  def create_projects?
    self.has_permission?(:create_projects)
  end

  ##
  # Alias for create_project?
  #
  # @example
  #   current_user.create_projects
  #
  # @return [Boolean] true if the user can create projects, or false otherwise
  #
  # @author lamb
  #
  # @see create_projects?
  #
  # @api public
  alias :create_projects :create_projects?

  ##
  # Check to see if any of the roles the user is in is an admin role
  #
  # @example
  #   current_user.admin=true
  #
  # @param [Boolean] is_admin True if the user should be an admin, or false
  # @return [nil] Not Interesting
  #
  # @author lamb
  #
  # @api public
  def create_projects=(can_create)
    role = Role.all(:project => nil, :admin => false).select{|role| role.has_permission?(:create_projects)}.first
    if can_create == true || can_create == 1 || can_create == '1'
      self.roles << role unless self.roles.include?(role)
    else
      self.roles.delete(role) if self.roles.include?(role)
    end
  end

end
