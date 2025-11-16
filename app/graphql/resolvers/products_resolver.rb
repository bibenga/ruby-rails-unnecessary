# frozen_string_literal: true

module Resolvers
  class ProductsResolver < BaseResolver
    type Types::ProductSummaryType.connection_type, null: true

    def resolve
      ::Product.order(name: :asc).all
    end
  end
end
