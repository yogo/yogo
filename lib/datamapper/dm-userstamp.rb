# Grabbed from http://github.com/rlivsey/dm-userstamp commit# d34936cc82cb860064bdb589fbf090b639435303
# and then customized.
# 
# In the User class, 
#   class User
#     ...
#     include DataMapper::Userstamp::Stamper
#     cattr_accessor :current_user
#     ...
#  end
# 
# TODO: Make the userclass customizable.

module DataMapper
  module Userstamp
    # module Stamper
    #   
    #   # This should never ever be called
    #   # @return [Object] nothing!
    #   # @api private
    #   def self.included(base)
    #     base.extend(ClassMethods)
    #   end
    # 
    #   module ClassMethods
    #     
    #     # This should never ever be called
    #     # @return [Object] nothing!
    #     # @api private
    #     def userstamp_class
    #       User
    #     end
    # 
    #     # Sets the current user for the current process
    #     # 
    #     # Only needs to be used when overwriting the current user
    #     # 
    #     # @example User.current_user = current_user
    #     # 
    #     # @param [User] user a user to set as the current user.
    #     # 
    #     # @return [Object] the current user. Not useful
    #     # 
    #     # @api semipublic
    #     def current_user=(user)
    #       Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"] = user
    #     end
    # 
    #     # Returns the current user for the current process
    #     # 
    #     # @example User.current_user
    #     #
    #     # @return [User] the current user. Not useful
    #     # @api semipublic
    #     def current_user
    #       Thread.current["#{self.to_s.downcase}_#{self.object_id}_stamper"]
    #     end
    #   end
    # end


    # This should never ever be called
    # @return [Object] nothing!
    # @api private
    def self.userstamp_class
      User
    end

    USERSTAMP_PROPERTIES = {
      :created_by_id => lambda { |r| r.created_by_id = userstamp_class.current.id if userstamp_class.current && r.new? && r.created_by_id.nil? },
      :updated_by_id => lambda { |r| r.updated_by_id = userstamp_class.current.id if userstamp_class.current}
    }
    
    # This should never ever be called
    # @return [Object] nothing!
    # @api private
    def self.included(model)
      model.before :save, :set_userstamp_properties
    end

    private
    # This should never ever be called
    # @return [Object] nothing!
    # @api private
    def set_userstamp_properties
      return unless Object.const_defined?(:User)
      self.class.properties.values_at(*USERSTAMP_PROPERTIES.keys).compact.each do |property|
        USERSTAMP_PROPERTIES[property.name][self]
      end
    end
  end

  DataMapper::Model.append_inclusions Userstamp
end