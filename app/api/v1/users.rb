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
        optional :_start, type: Integer, values: 0.., default: 0
        optional :_end, type: Integer, values: 1.., default: 10
        optional :_sort, type: String, values: ['id', 'nikname'], default: 'id'
        optional :_order, type: String, values: ['ASC', 'DESC'], default: 'ASC'
      end
      get do
        authenticate_user!

        total_count = User.count
        users = User
        if params[:_start].present? && params[:_end].present?
          users = users.offset(params[:_start]).limit(params[:_end] - params[:_start])
        end
        if params[:_sort].present? && params[:_order].present?
          users = users.order(params[:_sort] => params[:_order].to_sym)
        end
        header 'X-Total-Count', total_count
        present users, with: Entities::User
      end

      desc "Return a user."
      params do
        requires :id, type: Integer, desc: "User ID"
      end
      route_param :id do
        desc "Slected User" do
          entity Entities::User
          failure [ [ 404, "ResourceNotFound", "V1::Entities::Error" ] ]
        end
        get do
          authenticate_user!
          
          user = User.find(params[:id])
          present user, with: Entities::UserDetail
        end
      end
    end
  end
end
