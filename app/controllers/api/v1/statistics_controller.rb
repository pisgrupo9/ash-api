module Api
  module V1
    class StatisticsController < Api::V1::ApiController
      before_action :correct_dates, only: [:adoptions_by_week, :entry_by_week]
      respond_to :json

      def animals_by_species
        @species = Species.all
      end

      def adoptions_by_week
        @datos = Statistic.new.adoptions_by_week(params[:date_from], params[:date_to])
        render json: { datos: @datos }
      end

      def entry_by_week
        @datos = Statistic.new.entry_by_week(params[:date_from], params[:date_to], params[:species_id])
        render json: { datos: @datos }
      end

      private

      def correct_dates
        check_dates if params[:date_from].present? && params[:date_to].present?
      end

      def check_dates
        parse_date_to = Date.parse(params[:date_to])
        if parse_date_to > Date.today
          render json: { error: 'La fecha de fin no puede ser mayor a la fecha de hoy.' }, status: :unprocessable_entity
        elsif Date.parse(params[:date_from]) >= parse_date_to
          render json: { error: 'La fecha de fin debe ser mayor que la fecha de inicio.' }, status: :unprocessable_entity
        end
      end
    end
  end
end
