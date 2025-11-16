class NotificationChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "NotificationChannel.subscribed: #{current_user.id}; #{Time.now}"
    stream_from "notification"
  end

  def unsubscribed
    Rails.logger.info "NotificationChannel.unsubscribed: #{current_user.id}; #{Time.now}"
  end

  # def receive(data)
  #   Rails.logger.info "NotificationChannel.receive: #{current_user.id}; #{data};"
  # end
end
