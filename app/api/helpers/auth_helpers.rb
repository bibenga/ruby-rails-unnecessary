require_relative "../../errors/auth"

module AuthHelpers
  extend Grape::API::Helpers

  def current_user
    warden = env["warden"]
    # warden.authenticate(scope: :user)
    # warden.set_user(user, store: false)
    # puts "AAAAA"
    # pp warden.user
    # pp warden.authenticate!
    # puts "======"
    warden.user || warden.authenticate!
  end

  def authenticate_user!
    # puts "authenticate_user!"
    # error!("Unauthorized", 401) unless current_user
    # error!({ message: "Unauthorized", error: "Authentication credentials were not provided." }, 401) unless current_user
    raise NotAuthenticated unless current_user
  end
end
