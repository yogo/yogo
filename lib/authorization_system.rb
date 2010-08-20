module AuthorizationSystem

  ##
  # Callback for inclusion into a controller
  # @return [nil]
  # @api private
  def self.included(base)
    base.send :include, AuthorizationSystemInstanceMethods
  end

  module AuthorizationSystemInstanceMethods

    protected

    ##
    # The actions to take when authorization has been denied
    # 
    # @example
    #   authorization_denied
    # 
    # @return [False]
    #   Always returns false
    # 
    # @api semipublic
    def authorization_denied
      logger.debug { "Authorization Denied" }
      store_location
      flash[:notice] = "You don't have permission to view that page."
      # redirect_to new_user_session_url
      #TODO: Redirect back or default
      respond_to do |format|
        format.html do
          if !logged_in?
            redirect_to(login_url)
          elsif request.env['HTTP_REFERER'] 
            redirect_to(:back)
          else
            redirect_to('/')
          end
        end
      end
      return false
    end
  end # module AuthroizationSystemInstanceMethod
end
