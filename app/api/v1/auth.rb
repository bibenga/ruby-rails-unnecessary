require_relative "../../errors/auth"

module V1
  class Auth < Grape::API
    resource :auth do
      desc "Sign in user and return JWT token" do
        failure [
          [ 401, "AuthenticationError", "V1::Entities::Error" ],
          [ 403, "PermissionDenied", "V1::Entities::Error" ]
        ]
      end
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post :sign_in do
        user = User.find_for_database_authentication(email: params[:email])

        if user&.active? && user&.valid_password?(params[:password])
          # sign_in(user, store: false)
          env["warden"].set_user(user, store: false)
          # present user, with: API::Entities::UserEntity
          status 201
          {
            message: "Signed in successfully",
            user: { id: user.id, email: user.email, nikname: user.nikname }
          }
        else
          # error!("Invalid email or password", 401)
          raise AuthenticationFailed.new("Invalid email or password")
        end
      end

      desc "Sign out user"
      delete :sign_out do
        authenticate_user!
        env["warden"].logout(:user)
        status 204
        { message: "Signed out successfully" }
      end

      desc "Current user" do
        entity Entities::IAM
        failure [ [ 401, "Unauthorized", "V1::Entities::Error" ] ]
      end
      get :iam do
        authenticate_user!
        present current_user, with: Entities::IAM
      end

      desc "Notify" do
        failure [ [ 401, "Unauthorized", "V1::Entities::Error" ] ]
      end
      post :notify do
        # authenticate_user!
        ActionCable.server.broadcast(
          "notification",
          { type: "info", message: "Some message", id: 123 }
        )
        res = { status: :ok }
        status 200
        present res
      end
    end
  end
end
