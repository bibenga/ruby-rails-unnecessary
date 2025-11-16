# frozen_string_literal: true

require_relative "../helpers/auth_helper"

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Helpers::AuthenticationHelper
  end
end
