module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::Authenticable
      layout false
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from ActionController::UnknownController, with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from PermissionsHelper::ForbiddenAccess,  with: :render_forbidden_access

      def status
        render json: { online: true }
      end

      def render_forbidden_access(exception)
        logger.info(exception) # for logging
        render json: { error: 'No autorizado' }, status: :forbidden
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        render json: { error: 'No se encontró el registro' }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info(exception) # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end
    end
  end
end
