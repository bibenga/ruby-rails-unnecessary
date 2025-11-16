module Mutations
  class SignOut < BaseMutation
    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve
      user = context[:current_user]
      return { success: false, errors: [ "Not authenticated" ] } unless user

      warden = context[:warden]
      warden.logout(:user)

      { success: true, errors: [] }
    rescue JWT::DecodeError
      { success: false, errors: [ "Invalid token" ] }
    end
  end
end
