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

      def show
        @user = current_user
      end

      def comments
        user = current_user
        @comments = user.comments
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
