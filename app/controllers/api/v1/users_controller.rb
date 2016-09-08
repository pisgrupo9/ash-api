module Api
  module V1
    class UsersController < Api::V1::ApiController
      # PUT /api/v1/users/:id
      def update
        if current_user.update(user_params)
          render json: current_user
        else
          render json: { error: current_user.errors.as_json }, status: :bad_request
        end
      end

      def index
        @users = User.all
        authorize User
        render json: @users
      end

      def isanimalsedit
        @permiso = current_user.permissions
        authorize User
        render json: @permiso
      end

      def isadoptersedit
        @permiso = current_user.permissions
        authorize User
        render json: @permiso
      end

      def isdefaultuser
        @permiso = current_user.permissions
        authorize User
        render json: @permiso
      end

      private

      def render_bad_request
        head :bad_request
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name)
      end
    end
  end
end
