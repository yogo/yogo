module AuthorizationSystem

  def self.included(base)
    base.send :include, AuthorizationSystemInstanceMethods
    base.send :extend, AuthorizationSystemClassMethods

    base.send :class_inheritable_accessor, :authorization_requirements
    base.send :authorization_requirements=, []

    base.send :hide_action, 
              :authorization_requirements,
              :authorization_requirements=

    base.send :before_filter, :check_authorization
  end

  module AuthorizationSystemClassMethods
  
    # This is where initialzation could be, should be happening.
    # Baised on options passed in, decide how to do it
    #
    # Example Usage
    #
    
    def require_authorization(type, values, options = {})
      options.assert_valid_keys(:if, :unless, :only, :for, :except, :redirect_url, :render_url, :status)
    
      values = [values] unless Array === values
    
      for key in [:only, :except, :for]
        if options.has_key?(key)
          options[key] = [options[key]] unless Array === options[key]
          options[key] = options[key].compact.collect{|v| v.to_sym}
        end
      end
    
      self.authorization_requirements ||=[]
      self.authorization_requirements << {:type => type, :values => values, :options  => options}
    end
  
  def method_missing(method_id, *arguments)
    method_type = method_id.to_s.match(/^(authorize)_([_a-zA-Z]\w*)$/)
    super if method_type.nil? && !respond_to?("user_is_in_#{method_type[2]}?")
    require_authorization(method_type[2], *arguments)
  end
  
  ##
  # 
  # @author Yogo Team
  # 
  # @api private
  def next_authorized_action_for(user, params = {}, binding = self.binding)
    return nil unless Array===self.authorization_requirements
    self.authorization_requirements.each do |requirement|
      type = requirement[:type]
      values = requirement[:values]
      options = requirement[:options]
    
      if options.has_key?(:only)
        next unless options[:only].include?( (params[:action]||"index").to_sym )
      end
    
      if options.has_key?(:for)
        next unless options[:for].include?( (params[:action]||"index").to_sym )
      end
    
      if options.has_key?(:except)
        next if options[:except].include?( (params[:action]||"index").to_sym )
      end
    
      if options.has_key?(:if)
        next unless ( String==options[:if] ? eval(options[:if], binding) : options[:if].call(params) )
      end
    
      if options.has_key?(:unless)
        next if ( String===options[:unless] ? eval(options[:unless], binding) : options[:unless].call(params) )
      end
    
      values.each { |value| 
        return { :url => options[:redirect_url], :status => options[:status] } unless 
                 (user and send("user_is_in_#{type}?", user, value))
      } unless (user == :false || user == false)
           
    end
    return nil
  end
  
  def url_authorized?(user, params = {}, binding = self.binding)
    if !user.nil? 
      return self.next_authorized_action_for(user, params, binding).nil?
    end
    return true
  end
  
  
  def reset_authorization_requirements!
    self.authorization_requirements.clear
  end

  def user_is_in_group?(user, group)
    user.has_group?(group)
  end

  
  end # module AuthorizationSystemClassMethods

  module AuthorizationSystemInstanceMethods
  
    protected
  
    ##
    # The actions to take when authorization has been denied
    # 
    # @return [FalseClass]
    #   Always returns false
    # 
    # @api public
    def authorization_denied
      logger.debug { "Authorization Denied" }
      store_location
      flash[:notice] = "You've been denied."
      redirect_to new_user_session_url
      #TODO: Redirect back or default
      return false
    end
  
    # What to return when the user is authorized
    def authorized
      true
    end
  
    # Checks the authorization of the current user.
    # Returns the proper results if
    ##
    # Checks the authorizations for the current action being taken.
    # 
    # @returns [TrueClass or FalseClass]
    #   Returns true if authorized, and false if not authorized.
    # 
    # @author Yogo Team
    # 
    # @api public
    def check_authorization
      # return authorized if admin_groups.length > 0
      return authorization_denied unless self.url_authorized?(params)
      return authorized
    end
    
    def url_authorized?(params = {})
      params = params.symbolize_keys
      if params[:controller]
        base = eval("#{params[:controller]}_controller".classify)
      else
        base = self.class
      end
      base.url_authorized?(current_user, params, binding)  
    end
  
  end # module AuthroizationSystemInstanceMethod

end