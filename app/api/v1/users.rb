module V1
  class Users < Grape::API
    # version "v1", using: :path
    # format :json
    # default_error_formatter :json

    desc "Users" do
      produces [ "application/json" ]
    end
    resource :users do
      desc "All users" do
        entity Entities::User
        is_array true
      end
      params do
        optional :nikname, type: String
        optional :active, type: Boolean
        optional :_start, type: Integer, values: 0.., default: 0
        optional :_end, type: Integer, values: 1.., default: 10
        optional :_sort, type: String, values: [ "id", "nikname" ], default: "id"
        optional :_order, type: String, values: [ "ASC", "DESC" ], default: "ASC"
      end
      get do
        authenticate_user!

        # pp params

        total_count = User.count
        users = User
        if params[:nikname].present?
          users = users.where(User.arel_table[:nikname].matches("%#{params[:nikname]}%"), nil, true)
        end
        if !params[:active].nil?
          users = users.where(active: params[:active])
        end
        if params[:_start].present? && params[:_end].present?
          users = users.offset(params[:_start]).limit(params[:_end] - params[:_start])
        end
        if params[:_sort].present? && params[:_order].present?
          users = users.order(params[:_sort] => params[:_order].to_sym)
        end
        header "X-Total-Count", total_count
        present users, with: Entities::User
      end

      route_param :id do
        desc "Return a user."
        params do
          requires :id, type: Integer, desc: "User ID"
        end
        desc "Slected User" do
          entity Entities::User
          failure [ [ 404, "ResourceNotFound", "V1::Entities::Error" ] ]
        end
        get do
          authenticate_user!

          user = User.find(params[:id])
          present user, with: Entities::UserDetail
        end

        desc "Update a user" do
          entity Entities::ProductDetail
          failure [
            [ 401, "Unauthorized", "V1::Entities::Error" ],
            [ 403, "PermissionDenied", "V1::Entities::Error" ],
            [ 404, "ResourceNotFound", "V1::Entities::Error" ],
            [ 422, "ValidationError", "V1::Entities::Error" ]
          ]
        end
        params do
          optional :nikname, type: String, allow_blank: false
          optional :active, type: Boolean
        end
        put do
          authenticate_user!

          # pp params

          user = User.find(params[:id])

          user.nikname = params[:nikname] if params[:nikname].present?
          user.active = params[:active] if !params[:active].nil?

          if user.save
            present user, with: Entities::User
          else
            error!({ error: user.errors.full_messages }, 422)
          end
        end
      end
    end
  end
end
