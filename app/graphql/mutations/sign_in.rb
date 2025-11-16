# frozen_string_literal: true

module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::IamType, null: true
    field :errors, [ String ], null: false

    def resolve(email:, password:)
      user = User.find_for_database_authentication(email: email)
      if user.active? && user&.valid_password?(password)

        warden = context[:warden]
        warden.set_user(user, store: false)
        token = warden.env["warden-jwt_auth.token"]

        { user: user, token: token, errors: [] }
      else
        { user: nil, token: nil, errors: [ "Invalid credentials" ] }
      end
    end
  end
end
