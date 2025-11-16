class ApiError < StandardError
end

class AuthenticationFailed < ApiError
  # status_code = 401
  # default_detail = 'Incorrect authentication credentials.'
end

class NotAuthenticated < ApiError
  # status_code = 401
  # default_detail = 'Authentication credentials were not provided.'
end

class PermissionDenied < ApiError
  # status_code = 403
  # default_detail = "You do not have permission to perform this action."
end
