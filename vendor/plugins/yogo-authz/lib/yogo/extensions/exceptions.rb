module Yogo
  
  # Base Error
  class AuthorizationError < StandardError
  end
  
  class AuthorizationMissingPermissions < AuthorizationError
  end
  
  class AuthorizationExpressionInvalid < AuthorizationError
  end
  
  class UserMethodOnAnonymousUser < StandardError
  end
end