# frozen_string_literal: true

module Types
  class ProductDetailType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
    field :inventory_count, Integer, null: false
    field :comments, [ Types::CommentType ], null: true
  end
end
