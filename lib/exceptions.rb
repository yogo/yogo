# Base Error
class AuthorizationError < StandardError
end

# class AuthorizationMissingPermissions < AuthorizationError
# end
# 
# class AuthorizationExpressionInvalid < AuthorizationError
# end
# 
# class UserMethodOnAnonymousUser < StandardError
# end
# 

class AuthenticationError < StandardError
end

class PermissionError < StandardError
end

class NonExistantPermissionError < PermissionError
end