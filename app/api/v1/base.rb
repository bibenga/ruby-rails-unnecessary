require_relative "../helpers/auth_helpers"

module V1
  class Base < Grape::API
    version "v1", using: :path
    format :json
    default_error_formatter :json

    helpers AuthHelpers

    resource :status do
      desc "Status" do
        security [
          { bearer_auth: [] },
          { basic: [] },
          {}
        ]
        entity ::Entities::Status
      end
      get do
        user = current_user
        status = {
          message: "v1",
          user: user&.id
        }
        present status, with: ::Entities::Status
      end
    end

    mount Auth
    mount Users
    mount Products
  end
end
