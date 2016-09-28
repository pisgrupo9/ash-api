module Api
  module V1
    class EventsController < Api::V1::ApiController
      before_action :set_animal
      def index
        @events = @animal.events.page(params[:page]).per(params[:row])
      end

      def show
        @event = @animal.events.find(params[:id])
      end

      def create
        authorize @animal
        event = @animal.events.build(event_params)
        if event.save
          render json: {}, status: :created
        else
          render json: { error: event.errors.as_json }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize @animal
        @event = @animal.events.find(params[:id])
        @event.destroy
        head :no_content
      end

      private

      def set_animal
        @animal = Animal.find(params[:animal_id])
      end

      def event_params
        params.require(:event).permit(:name, :description, :date)
      end
    end
  end
end
