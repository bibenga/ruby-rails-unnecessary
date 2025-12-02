class ProductWasViewedJob < ApplicationJob
  queue_as :default

  def perform(product, user)
    if user.nil?
      logger.info "The product #{product.id} was viewed by anonymous user"
    else
      logger.info "The product #{product.id} was viewed by user #{user&.id}"
    end
  end
end
