class ProductWasViewedJob < ApplicationJob
  queue_as :default

  def perform(product, user)
    if user.nil?
      logger.info "The product #{product.id} was viewed by anonymous user"
      ProductCounter.upsert(
        { product_id: product.id, user_views_count: 0, anonymous_views_count: 1 },
        unique_by: :product_id,
        update_only: [ :user_views_count ]
      )
    else
      logger.info "The product #{product.id} was viewed by user #{user&.id}"
      ProductCounter.upsert(
        { product_id: product.id, user_views_count: 1, anonymous_views_count: 0 },
        unique_by: :product_id,
        update_only: [ :user_views_count ]
      )
    end
  end
end
