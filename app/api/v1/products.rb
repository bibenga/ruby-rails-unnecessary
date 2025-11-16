module V1
  class Products < Grape::API
    # version "v1", using: :path
    # format :json
    # default_error_formatter :json

    desc "Products" do
      produces [ "application/json" ]
    end
    resource :products do
      desc "All products" do
        entity Entities::ProductSummaryList
        # is_array true
        failure [ [ 422, "ValidationError", "V1::Entities::Error" ] ]
      end
      params do
        optional :page, type: Integer, values: 1.., desc: "Page number", default: 1
        optional :per_page, type: Integer, values: 2..50, desc: "Items per page", default: 5
      end
      get do
        per_page = params[:per_page] || 10
        products = Product.order(name: :asc).page(params[:page]).per(per_page).all

        # present products, with: Entities::ProductSummary
        # present products, with: Entities::ProductSummary, meta: {
        #   current_page: products.current_page,
        #   total_pages:  products.total_pages,
        #   total_count:  products.total_count
        # }

        {
          data: Entities::ProductSummary.represent(products),
          meta: {
            current_page: products.current_page,
            per_page: per_page,
            total_pages: products.total_pages,
            total_count: products.total_count
          }
        }
      end

      desc "Create a product" do
        entity Entities::ProductDetail
        failure [
          [ 401, "Unauthorized", "V1::Entities::Error" ],
          [ 403, "PermissionDenied", "V1::Entities::Error" ],
          [ 422, "ValidationError", "V1::Entities::Error" ]
        ]
      end
      params do
        requires :name, type: String, desc: "Product name", allow_blank: false
        optional :description, type: String, desc: "product description", allow_blank: false
      end
      post do
        authenticate_user!

        product = Product.new(declared(params))
        product.description = params[:description] if params[:description].present?
        if product.save
          present product, with: Entities::ProductDetail, status: 201
        else
          error!({ error: product.errors.full_messages }, 422)
        end
      end

      route_param :id do
        desc "Return a product" do
          entity Entities::ProductDetail
          failure [ [ 404, "ResourceNotFound", "V1::Entities::Error" ] ]
        end
        # params do
        #   requires :id, type: Integer, desc: "Product ID"
        # end
        get do
          product = Product.includes(:rich_text_description, comments: :user).find(params[:id])
          present product, with: Entities::ProductDetail
        end

        desc "Update a product" do
          entity Entities::ProductDetail
          failure [
            [ 401, "Unauthorized", "V1::Entities::Error" ],
            [ 403, "PermissionDenied", "V1::Entities::Error" ],
            [ 404, "ResourceNotFound", "V1::Entities::Error" ],
            [ 422, "ValidationError", "V1::Entities::Error" ]
          ]
        end
        params do
          # requires :id, type: Integer, desc: "Product ID"
          optional :name, type: String, desc: "Product name", allow_blank: false
          optional :description, type: String, desc: "product description", allow_blank: false
        end
        put do
          authenticate_user!

          product = Product.includes(:rich_text_description, comments: :user).find(params[:id])
          # error!({ error: "product not found" }, 404) unless product

          product.name = params[:name] if params[:name]
          product.description = params[:description] if params[:description]

          if product.save
            present product, with: Entities::ProductDetail
          else
            error!({ error: product.errors.full_messages }, 422)
          end
        end

        desc "Delete a product" do
          failure [
            [ 401, "Unauthorized", "V1::Entities::Error" ],
            [ 403, "PermissionDenied", "V1::Entities::Error" ],
            [ 404, "ResourceNotFound", "V1::Entities::Error" ]
          ]
        end
        delete do
          authenticate_user!

          product = Product.find(params[:id])
          # error!({ error: "product not found" }, 404) unless product

          product.destroy
          status 204
          { id: product.id }
        end
      end
    end
  end
end
