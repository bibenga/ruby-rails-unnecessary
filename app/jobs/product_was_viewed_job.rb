class ProductWasViewedJob < ApplicationJob
  queue_as :default

  def perform(product, user)
    ProductCounter.transaction do
      counter = ProductCounter.lock.find_or_create_by!(product: product)
      if user.nil?
        logger.info "The product #{product.id} was viewed by anonymous user"
        counter.increment!(:anonymous_views_count, touch: true)
      else
        logger.info "The product #{product.id} was viewed by user #{user&.id}"
        counter.increment!(:user_views_count, touch: true)
      end
    end
  end
end
