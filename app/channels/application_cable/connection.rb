module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      Rails.logger.info "ApplicationCable: connect; #{Time.now}"

      self.current_user = find_verified_user

      Rails.logger.info "ApplicationCable: connected; #{self.current_user.id}"
    end

    def disconnect
      Rails.logger.info "ApplicationCable: disconnected; #{self.current_user.id}"
    end

    def beat
      super
      Rails.logger.info "ApplicationCable.beat: #{current_user.id};"
    end

    private

    def find_verified_user
      token = request.params[:token]
      return reject_unauthorized_connection unless token

      jwt_payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      user = User.find_by(id: jwt_payload["sub"])

      user || reject_unauthorized_connection
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      reject_unauthorized_connection
    end
  end
end
