module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { error: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { error: e.message }, status: :unprocessable_entity
    end

    rescue_from ActionController::BadRequest do |e|
      render json: { error: e.message }, status: :bad_request
    end

    rescue_from ActionController::RoutingError do |e|
      render json: { error: e.message }, status: :not_found
    end

    rescue_from StandardError do |e|
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
