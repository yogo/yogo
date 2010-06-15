# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: anonymous_user.rb
# Anonymous user object. Returned when a user isn't logged in.
# NOTE: This is not currently being used
class AnonymousUser
  
  ##
  # Anonymous user name
  # 
  # The name given the the anonymous user.
  # 
  # @example
  #   current_user.name
  # 
  # @return [String] the name to use for the anonymous user
  # 
  # @api private
  def name
    Yogo::Setting[:anonymous_user_name]
  end
  
  ##
  # Analgous to the User has_group? method
  # 
  # Will return true if the anonymous user group name was passed in.
  # 
  # @example
  #   @current_user.has_group?(:anonymous_group)
  # 
  # @param [String or Symbol]
  #   The group name to test for
  # 
  # @return [Boolean]
  #   True if the anonymous group is passed in or false otherwise.
  # 
  # @see User.has_group?
  # 
  # @api public
  def has_group?(value)
    return value.to_s.eql?(Yogo::Setting[:anonymous_user_group])
  end
  
  ##
  # Hey, a Method Missing
  # 
  # Checks to see if the method passed in was ment for a user.
  # 
  # @return [nil]
  # @author lamb
  # @api private
  def method_missing(method, *args)
    if User.new.respond_to?(method)
      raise UserMethodOnAnonymousUser.new("undefined method '#{method}' for #{self}. Did you mean to call it on a #{Yogo::Settings[:user_class]} class instead?")
    else
      raise NoMethodError.new("undefined method '#{method}' for #{self}")
    end
  end
  
  ##
  # An ID for the anonymous user
  # 
  # @example
  #   current_user.id
  # 
  # @return [0]
  # 
  # @api public
  def id
    0
  end
end