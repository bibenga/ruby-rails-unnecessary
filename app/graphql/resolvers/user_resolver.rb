# frozen_string_literal: true

module Resolvers
  class UserResolver < BaseResolver
    type Types::UserType, null: true
    argument :id, ID

    def resolve(id:)
      authenticate_user!
      ::User.find(id)
    end
  end
end
