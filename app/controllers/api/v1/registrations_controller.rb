module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      include Concerns::Authenticable
      before_action :configure_permitted_parameters, only: [:create]
      skip_before_filter :verify_authenticity_token, if: :json_request?
      before_action :set_admin, only: [:create]

      def create
        build_resource(sign_up_params)
        resource_saved = resource.save
        if resource_saved
          AdminMailer.new_user_mail(@admin).deliver_now
          UserMailer.welcome_email(resource).deliver_now
          render json: { email: resource.email }
        else
          save_fail
          render json: { error: resource.errors }, status: :bad_request
        end
      end

      protected

      def save_fail
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        @minimum_password_length = resource_class.password_length.min if @validatable
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.for :sign_up do |params|
          params.permit(
            :email, :first_name, :last_name, :password, :password_confirmation, :phone
          )
        end
      end

      def json_request?
        request.format.json?
      end

      def set_admin
        @admin = AdminUser.first
      end
    end
  end
end
