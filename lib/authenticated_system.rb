module AuthenticatedSystem

  ##
  # Callback for inclusion into a controller
  # @example
  #   included
  # @return [nil]
  # @api private
  def self.included(base)
    base.send(:include, AuthenticatedSystemInstanceMethods)
    # base.send(:extend,  AuthenticatedSystemClassMethods)
    
    base.send(:helper_method, :logged_in?, :current_user)
  end

  # module AuthenticatedSystemClassMethods
  #   
  #   def require_user(options = {})
  #     authorize_group(:default, options)
  #   end
  #   
  #   alias_method :login_required, :require_user
  # 
  #   def require_no_user(options = {})
  #     authorize_group(:anonymous, options)
  #   end
  # end


  module AuthenticatedSystemInstanceMethods
    protected

    ##
    # Checks to see if the current user has been authenticated
    # 
    # @example
    #   if not_logged_in?
    #     # do something
    #   end
    # 
    # @return [TrueClass or FalseClass]
    #   Returns true if the current user has not been authenticated
    # 
    # @author lamb
    # 
    # @api semipublic
    def not_logged_in?
      !logged_in?
    end

    ##
    # Makes sure a user is logged in
    # 
    # @example
    #   require_user
    # 
    # @return [nil or False]
    #  Redirects to the login page if the user isn't currently logged in
    # 
    # @author lamb
    # 
    # @api semipublic
    def require_user
      unless logged_in?
        store_location
        flash[:notice] = "Please log in to access the requested page"
        redirect_to login_url
        return false
      end
    end

    ##
    # Makes sure a user is logged in
    # 
    # @example
    #   authentication_required
    # 
    # @return [nil or False]
    #  Redirects to the login page if the user isn't currently logged in
    # 
    # @author lamb
    # @see require_user
    # @api semipublic
    alias :authentication_required :require_user

    ##
    # Makes sure a user is not logged in
    # 
    # @example
    #   require_no_user
    # 
    # @return [nil or False]
    #  Redirects to the '/' if the user is currently logged in
    # 
    # @author lamb
    # 
    # @api semipublic
    def require_no_user
      if logged_in?
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to '/'
        return false
      end
    end

    ##
    # Saves the location of a request in the esssion
    # 
    # @example
    #   store_location
    # 
    # @return [nil]
    #   Nothing useful
    # 
    # @author lamb
    # 
    # @api semipublic
    def store_location
      if request.method.eql?(:get)
        session[:return_to] = request.request_uri
      elsif request.env["HTTP_REFERER"] != nil
        session[:return_to] = request.env["HTTP_REFERER"]
      else
        session[:return_to] = nil
      end
    end

    ##
    # Redirects to what's saved in the session or the passed in path
    # 
    # @example
    #   redirect_back_or_default('/')
    # 
    # @return [nil]
    #   Nothing useful
    # 
    # @author lamb
    # 
    # @api semipublic
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end
end