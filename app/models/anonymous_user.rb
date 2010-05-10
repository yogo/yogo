# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: anonymous_user.rb
# Anonymous user object. Returned when a user isn't logged in.
class AnonymousUser
  
  def name
    Yogo::Settings[:anonymous_user_name]
  end
  
  def has_group?(value)
    return value.to_s.eql?(Yogo::Settings[:anonymous_user_group])
  end
  
  def method_missing(method, *args)
    if User.new.respond_to?(method)
      raise UserMethodOnAnonymousUser.new("undefined method '#{method}' for #{self}. Did you mean to call it on a #{Yogo::Settings[:user_class]} class instead?")
    else
      raise NoMethodError.new("undefined method '#{method}' for #{self}")
    end
    
  end
end