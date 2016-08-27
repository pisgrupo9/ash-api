module Api
  module V1
    module Concerns
      module Authenticable
        extend ActiveSupport::Concern
        included do
          before_action :ensure_authenticated_user!, unless: :non_authenticable_methods
        end

        def ensure_authenticated_user!
          return true if current_user.present?
          render json: { errors: ['You need to provide a valid token and email'] }, status: :unauthorized
        end

        # TODO, rethink this and evaluate to move this to independent
        # skip_before_action callbacks on individual controllers

        def non_authenticable_methods
          non_authenticable_devise_methods || non_authenticable_api_methods
        end

        def non_authenticable_api_methods
          controller_name == 'api' && action_name == 'status'
        end

        def non_authenticable_devise_methods
          non_authenticable_sessions || non_authenticable_registrations || non_authenticable_passwords
        end

        def non_authenticable_sessions
          devise_controller? && controller_name == 'sessions' &&
            (action_name == 'create' || action_name == 'failure')
        end

        def non_authenticable_registrations
          (devise_controller? && controller_name == 'registrations' && action_name == 'create')
        end

        def non_authenticable_passwords
          (devise_controller? && controller_name == 'passwords' && (action_name == 'create' || action_name == 'update'))
        end

        private

        # Override this method in order to get the current user using only the auth token
        def find_record_from_identifier(entity)
          user_token = request.headers['X-USER-TOKEN']
          super if entity.model != User || user_token.blank?
          User.find_by authentication_token: user_token
        end
      end
    end
  end
end
