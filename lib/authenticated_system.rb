module AuthenticatedSystem

  def self.included(base)
    base.send(:include, AuthenticatedSystemInstanceMethods)
    base.send(:extend,  AuthenticatedSystemClassMethods)
    
    base.send(:helper_method, :logged_in?, :current_user)
  end

  module AuthenticatedSystemClassMethods
    
    def require_user(options = {})
      authorize_group(:default, options)
    end
    
    alias_method :login_required, :require_user

    def require_no_user(options = {})
      authorize_group(:anonymous, options)
    end
  end


  module AuthenticatedSystemInstanceMethods
    protected

    ##
    # Returns the current user session, if they are logged in.
    # 
    # @returns [UserSession]
    #   The current user session
    # 
    # @author lamb
    # 
    # @api semipublic
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    ##
    # Returns the current user session, if they are logged in.
    # 
    # @returns [User or AnonymousUser]
    #   Returns the current user for the sessions
    # 
    # @author lamb
    # 
    # @api semipublic
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = (current_user_session && current_user_session.record) || AnonymousUser.new
    end

    ##
    # Checks to see if the current user has been authenticated
    # 
    # @example
    #   if logged_in?
    #     # do something
    #   end
    # 
    # @returns [TrueClass or FalseClass]
    #   Returns true if the current user has been authenticated
    # 
    # @author lamb
    # 
    # @api public
    def logged_in?
      (current_user_session && current_user_session.record)
    end

    ##
    # Checks to see if the current user has been authenticated
    # 
    # @example
    #   if not_logged_in?
    #     # do something
    #   end
    # 
    # @returns [TrueClass or FalseClass]
    #   Returns true if the current user has not been authenticated
    # 
    # @author lamb
    # 
    # @api public
    def not_logged_in?
      !logged_in?
    end

    def require_user
      unless logged_in?
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if logged_in?
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to '/'
        return false
      end
    end

    def store_location
      if request.method.eql?(:get)
        session[:return_to] = request.request_uri
      elsif request.env["HTTP_REFERER"] != nil
        session[:return_to] = request.env["HTTP_REFERER"]
      else
        session[:return_to] = nil
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
  end
end