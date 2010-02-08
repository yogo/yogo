# Yogo Authorization Module
# Copyright (c) 2009 Montana State University
#
# FILE: authenticated_system.rb
# Implementing an authentication system.
module Yogo
  module AuthenticatedSystem
    
    def self.included(base)
    
      base.send :include, AuthenticatedSystemInstanceMethods
      base.send :extend, AuthenticatedSystemClassMethods
    
      base.send :class_inheritable_accessor, :authenication_requirements
      base.send :authenication_requirements=, []
    
      base.send :class_inheritable_accessor, :declaired_auths
      base.send :declaired_auths=, false
    
      base.send :hide_action, 
                :authenication_requirements, 
                :authenication_requirements=,
                :declaired_auths,
                :declaired_auths=
      
      base.send :helper_method, :logged_in?, :current_user
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
      
        def current_user_session
          return @current_user_session if defined?(@current_user_session)
          @current_user_session = Yogo::UserSession.find
        end

        def current_user
          return @current_user if defined?(@current_user)
          @current_user = (current_user_session && current_user_session.record) || Yogo::AnonymousUser.new
        end
        
        def logged_in?
          (current_user_session && current_user_session.record)
        end
        
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
          session[:return_to] = request.request_uri
        end

        def redirect_back_or_default(default)
          redirect_to(session[:return_to] || default)
          session[:return_to] = nil
        end
        
    end
  end
end