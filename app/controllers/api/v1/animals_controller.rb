module Api
  module V1
    class AnimalsController < Api::V1::ApiController
      before_action :set_animal, except: [:index, :create]
      respond_to :json

      def index
        @animals = Animal.all
      end

      def show
      end

      def create
        authorize Animal
        animal = Animal.new(animal_params)
        if animal.save
          render json: animal.as_json(only: [:id]), status: :created
        else
          render json: { error: animal.errors.as_json }, status: :unprocessable_entity
        end
      end

      def update
        authorize Animal
        if @animal.update(animal_update_params)
          render json: @animal.as_json(only: [:id]), status: :ok
        else
          render json: { error: @animal.errors.as_json }, status: :bad_request
        end
      end

      def destroy
        authorize Animal
        @animal.destroy
        head :no_content
      end

      private

      def set_animal
        @animal = Animal.find(params[:id])
      end

      def animal_params
        params.require(:animal).permit(:chip_num, :name, :race, :sex, :vaccines,
                                       :castrated, :admission_date, :birthdate, :death_date, :species_id)
      end

      def animal_update_params
        params.require(:animal).permit(:race, :sex, :vaccines,
                                       :castrated, :admission_date, :birthdate, :death_date)
      end
    end
  end
end
