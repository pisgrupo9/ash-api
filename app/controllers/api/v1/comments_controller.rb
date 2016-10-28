module Api
  module V1
    class CommentsController < Api::V1::ApiController
      before_action :set_adopter

      def index
        @comments = @adopter.comments
      end

      def show
        @comment = @adopter.comments.find(params[:id])
      end

      def create
        authorize Adopter
        comment = @adopter.comments.build(text: comment_params[:text], user_id: current_user.id)
        if comment.save
          render json: comment.as_json(only: [:id]), status: :created
        else
          render json: { error: comment.errors.as_json }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize Adopter
        @comment = @adopter.comments.find(params[:id])
        @comment.destroy
        head :no_content
      end

      private

      def set_adopter
        @adopter = Adopter.find(params[:adopter_id])
      end

      def comment_params
        params.require(:comment).permit(:text)
      end
    end
  end
end
