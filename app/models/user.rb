require 'datamapper/authlogic/compatability'
class User
  include DataMapper::Resource
  include DataMapper::Authlogic::Compatability
  include SentientUser

  attr_accessor :password_confirmation

  property :id,                 DataMapper::Types::Serial
  property :login,              String, :required => true, :index => true
  property :email,              String, :required => true, :length => 256
  property :first_name,         String, :required => true, :length => 50
  property :last_name,          String, :required => true, :length => 50  

  # TODO: Make sure a length of 128 is long enough for various encryption algorithms.
  property :crypted_password,     String, :required => true,  :length => 128
  property :password_salt,        String, :required => true,  :length => 128
  property :persistence_token,    String, :required => true,  :length => 128, :index => true

  if Yogo::Setting[:allow_api_key] == true
    property :single_access_token,  String, :required => false, :length => 128, :index => true
  end

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

  acts_as_authentic do |config| 
    config.instance_eval do
      validates_uniqueness_of_email_field_options :scope => :id
      validate_login_field false
    end
  end
  
  ##
  # Finds a user by their login.
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
  
end