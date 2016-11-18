module Api
  module V1
    class AdoptionsController < Api::V1::ApiController
      before_action :set_adoption, only: [:show, :destroy]
      before_action :find_adopter, only: [:create]
      before_action :find_animal, only: [:create]
      respond_to :json

      def show
      end

      def create
        authorize Adoption
        adoption = Adoption.new(adoption_params)
        if adoption.save
          render json: adoption.as_json(only: [:id]), status: :created
        else
          render json: { error: adoption.errors.as_json }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize Adoption
        @adoption.destroy
        head :no_content
      end

      private

      def set_adoption
        @adoption = Adoption.find(params[:id])
      end

      def adoption_params
        params.require(:adoption).permit(:adopter_id, :animal_id, :date)
      end

      def find_adopter
        Adopter.find(adoption_params[:adopter_id])
      end

      def find_animal
        Animal.find(adoption_params[:animal_id])
      end
    end
  end
end
