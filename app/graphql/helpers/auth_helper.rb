require_relative "../../errors/auth"

module Helpers
  module AuthenticationHelper
    def current_user
      context[:current_user]
    end

    def authenticate_user!
      # raise GraphQL::ExecutionError, "Authentication required" unless current_user
      raise NotAuthenticated unless current_user
    end
  end
end
