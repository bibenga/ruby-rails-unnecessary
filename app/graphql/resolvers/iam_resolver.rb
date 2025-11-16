# frozen_string_literal: true

module Resolvers
  class IamResolver < BaseResolver
    type Types::IamType, null: true

    def resolve
      # context[:current_user]
      authenticate_user!
      current_user
    end
  end
end
