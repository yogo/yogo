# Base Error
class AuthorizationError < StandardError
end

class AuthenticationError < StandardError
end

class PermissionError < StandardError
end

class NonExistantPermissionError < PermissionError
end