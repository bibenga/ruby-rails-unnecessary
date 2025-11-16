# frozen_string_literal: true

module Types
  class IamType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :nikname, String
  end
end
