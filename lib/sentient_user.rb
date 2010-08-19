# Grabbed from http://github.com/bokmann/sentient_user
module SentientUser
  
  ##
  # Callback for inclusion into a User
  # @return [nil]
  # @api private
  def self.included(base)
    base.class_eval {
      
      ##
      # Get the current user from this thread
      # 
      # @example
      #   User.current # returns the current user
      # 
      # @return [User or AnonymousUser or nil]
      #  The current user in this thread
      # 
      # @api public
      def self.current
        Thread.current[:user]
      end

      ##
      # Sets the current user for the thread.
      # 
      # @example
      #   User.current = current_user
      # 
      # @param [User]
      #  The user to be set to the current user.
      # @return
      #   The user that was just set.
      # 
      # @raise [ArgumentError] Error if an object other then User is passed in
      # 
      # @api public
      def self.current=(o)
        raise(ArgumentError,
            "Expected an object of class '#{self}', got #{o.inspect}") unless (o.is_a?(self) || o.nil?)
        Thread.current[:user] = o
      end
  
  
      ##
      # Make the this user the current user
      # 
      # @example
      #   a_user.make_current
      # 
      # @return Returns self
      # 
      # @api public
      def make_current
        Thread.current[:user] = self
      end

      ##
      # Check to see if the user is the current user
      # 
      # @example
      #   a_user.current?
      # 
      # @returns [TrueClass or FalseClass]
      #   If the user object is the current user or not.
      # 
      # @api public
      def current?
        !Thread.current[:user].nil? && self.id == Thread.current[:user].id
      end
    }
  end
end


