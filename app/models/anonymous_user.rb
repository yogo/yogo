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
    Setting[:anonymous_user_name]
  end

  ##
  # Analgous to the User has_role? method
  #
  # Will return true if the anonymous user role name was passed in.
  #
  # @example
  #   @current_user.has_role?(:anonymous_role)
  #
  # @param [String or Symbol]
  #   The role name to test for
  #
  # @return [Boolean]
  #   True if the anonymous role is passed in or false otherwise.
  #
  # @see User.has_role?
  #
  # @api public
  def has_role?(value)
    return value.to_s.eql?(Setting[:anonymous_user_role])
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
      raise UserMethodOnAnonymousUser.new("undefined method '#{method}' for #{self}. Did you mean to call it on a #{Settings[:user_class]} class instead?")
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