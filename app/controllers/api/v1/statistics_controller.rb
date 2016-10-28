module Api
  module V1
    class StatisticsController < Api::V1::ApiController
      respond_to :json

      def animals_by_species
        @species = Species.all
      end

      def adoptions_by_week
        @datos = Statistic.new.adoptions_by_week(params[:date_from], params[:date_to])
        render json: { datos: @datos }
      end

      def entry_by_week
        @datos = Statistic.new.entry_by_week(params[:date_from], params[:date_to])
        render json: { datos: @datos }
      end
    end
  end
end
