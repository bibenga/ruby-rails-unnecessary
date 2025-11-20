module V1
  module Entities
    class Error < Grape::Entity
      expose :error, documentation: { type: "String" }
      expose :message, documentation: { type: "String" }
    end

    class Pagination < Grape::Entity
      expose :current_page, documentation: { type: "Integer" }
      expose :per_page, documentation: { type: "Integer" }
      expose :total_pages, documentation: { type: "Integer" }
      expose :total_count, documentation: { type: "Integer" }
    end

    class IAM < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User Id" }
      expose :email, documentation: { type: "String", desc: "Email" }
      expose :nikname, documentation: { type: "String", desc: "Nikname" }
    end

    class User < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User Id" }
      expose :nikname, documentation: { type: "String", desc: "Nikname" }
      expose :active, documentation: { type: "Boolean", desc: "Active" }
      expose :last_sign_in_at, documentation: { type: "String", desc: "Last sign in at" }
    end

    class UserDetail < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User Id" }
      expose :email, documentation: { type: "String", desc: "Email" }
      expose :nikname, documentation: { type: "String", desc: "Nikname" }
      expose :active, documentation: { type: "Boolean", desc: "Active" }
      expose :last_sign_in_at, documentation: { type: "String", desc: "Last sign in at" }
      expose :created_at, documentation: { type: "String", desc: "Created at" }
    end

    class DeletedUser < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "User Id" }
    end

    class ProductSummary < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "ProductId" }
      expose :name, documentation: { type: "String", desc: "Name" }
      expose :inventory_count, documentation: { type: "Integer", desc: "InventoryCount" }
    end

    class ProductSummaryList < Grape::Entity
      expose :data, using: ProductSummary, documentation: { is_array: true }
      expose :meta, using: Pagination
    end

    class ProductDetail < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "ProductId" }
      expose :name, documentation: { type: "String", desc: "Name" }
      expose :description, documentation: { type: "String", desc: "Description" } do |item|
        item.description&.body&.to_html
      end
      expose :inventory_count, documentation: { type: "Integer", desc: "InventoryCount" }
      expose :comments, using: "V1::Entities::Comment"
    end

    class Comment < Grape::Entity
      expose :id, documentation: { type: "Integer", desc: "Comment Id" }
      # expose :product_id, documentation: { type: "Integer", desc: "Product Id" }
      # expose :user_id, documentation: { type: "Integer", desc: "User Id" }
      expose :user, using: User
      expose :body, documentation: { type: "String", desc: "Body" }
      expose :created_at
    end
  end
end
