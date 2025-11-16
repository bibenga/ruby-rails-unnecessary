# frozen_string_literal: true

module Types
  class ProductSummaryType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :id, ID, null: false
    field :name, String, null: false
    field :inventory_count, Integer, null: false
  end
end
