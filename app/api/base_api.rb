require_relative "entities"
require_relative "../errors/auth"

class BaseApi < Grape::API
  format :json
  default_error_formatter :json
  prefix :api

  resource :status do
    desc "Status" do
      security [
        { bearer_auth: [] },
        # { api_key: [] },
        { basic: [] },
        {}
      ]
      entity Entities::Status
    end
    get do
      status = { message: "olala" }
      if @current_user
        status["user"] = @current_user.id
      end
      present status, with: Entities::Status
    end
  end

  rescue_from AuthenticationFailed do |e|
    error!({ error: "AuthenticationFailed", message: "Incorrect authentication credentials." }, 401)
  end

  rescue_from NotAuthenticated do |e|
    pp e
    error!({ error: "NotAuthenticated", message: "Authentication credentials were not provided." }, 401)
  end

  rescue_from PermissionDenied do |e|
    error!({ error: "PermissionDenied", message: "You do not have permission to perform this action." }, 403)
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: "RecordNotFound", message: e.message || "Resource not found" }, 404)
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({ error: "ValidationError", message: e.message || "Validation error" }, 422)
  end

  rescue_from :all do |e|
    error!({ error: "InternalError", message: e.message || "Internal error" }, 500)
  end

  mount V1::Base

  add_swagger_documentation(
    info: {
      title: "Ruby sucks",
      description: "Ruby is very strange."
    },
    api_version: "v1",
    hide_format: true,
    mount_path: "/swagger_doc",
    security_definitions: {
      bearer_auth: {
        type: "apiKey",
        name: "Authorization",
        in: "header"
      },
      basic: {
        type: "basic"
      }
    },
    security: [
      { bearer_auth: [] },
      { basic: [] }
    ],
    # global_responses: {
    #   404 => {
    #     description: "Resource not found",
    #     schema: {
    #       type: "object",
    #       properties: {
    #         message: { type: "string" },
    #         error: { type: "string" }
    #       },
    #       required: [ "message", "error" ]
    #     }
    #   },
    #   422 => {
    #     description: "Validation error",
    #     schema: {
    #       type: "object",
    #       properties: {
    #         message: { type: "string" },
    #         error: { type: "string" }
    #       },
    #       required: [ "message", "error" ]
    #     }
    #   },
    #   500 => {
    #     description: "Internal error",
    #     schema: {
    #       type: "object",
    #       properties: {
    #         message: { type: "string" },
    #         error: { type: "string" }
    #       },
    #       required: [ "message", "error" ]
    #     }
    #   }
    # }
  )
end
