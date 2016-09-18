module Api
  module V1
    class ImagesController < Api::V1::ApiController
      before_action :set_animal
      def show
        @image = @animal.images.find(params[:id])
      end

      def index
        @images = @animal.images.page(params[:page]).per(params[:row])
      end

      def create
        authorize @animal
        image = Image.new(file: image_params[:file], animal_id: params[:animal_id])
        if image.save
          render json: {}, status: :created
        else
          render json: { error: image.errors.as_json }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @animal
        @image = @animal.images.find(params[:id])
        @image.destroy
        head :no_content
      end

      private

      def set_animal
        @animal = Animal.find(params[:animal_id])
      end

      def image_params
        params.require(:image).permit(:file)
      end
    end
  end
end
