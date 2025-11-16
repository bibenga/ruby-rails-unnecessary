# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  # only for session? I don't know
  include Devise::Controllers::Helpers

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    context = {
      warden: warden,
      current_user: current_user_from_jwt_or_session
    }

    result = StoreSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue AuthenticationFailed, NotAuthenticated => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [ { message: e.message } ] }, status: :unauthorized
  rescue PermissionDenied => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [ { message: e.message } ] }, status: :forbidden
  rescue ApiError => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [ { message: e.message } ] }, status: :unprocessable_entity
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: :internal_server_error
  end

  def current_user_from_jwt_or_session
    return current_user if user_signed_in?

    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.starts_with?("Bearer ")

    token = auth_header.split(" ").last

    begin
      # use Warden / devise-jwt
      payload = Warden::JWTAuth::TokenDecoder.new.call(token)
      user_id = payload["sub"]

      User.find_by(id: user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end
end
