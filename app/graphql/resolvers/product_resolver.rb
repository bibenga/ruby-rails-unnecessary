# frozen_string_literal: true

module Resolvers
  class ProductResolver < BaseResolver
    type Types::ProductDetailType, null: true
    argument :id, ID

    def resolve(id:, lookahead:)
      # ::Product.includes(:rich_text_description, comments: :user).find(id)

      q = ::Product.where(id: id)

      if lookahead.selects?(:description)
        q = q.includes(:rich_text_description)
      end

      if lookahead.selects?(:comments)
        q = q.includes(:comments)
        comment_lookahead = lookahead.selection(:comments)
        if comment_lookahead.selects?(:user)
          q = q.includes(comments: :user)
        end
      end

      q.first!
    end
  end
end
