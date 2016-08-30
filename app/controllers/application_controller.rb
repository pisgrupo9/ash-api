class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  rescue_from ActionController::ParameterMissing do
    render json: { error: 'Parameter Missing' }, status: 400
  end
end
