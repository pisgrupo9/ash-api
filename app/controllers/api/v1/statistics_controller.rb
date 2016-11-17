module Api
  module V1
    class StatisticsController < Api::V1::ApiController
      before_action :correct_both_dates,
                    only: [:adoptions_by_week, :entry_by_week],
                    if: '!params[:date_to].nil? && !params[:date_from].nil?'
      before_action :correct_date_from,
                    only: [:adoptions_by_week, :entry_by_week],
                    if: 'params[:date_to].nil? && !params[:date_from].nil?'
      before_action :correct_date_to,
                    only: [:adoptions_by_week, :entry_by_week],
                    if: 'params[:date_from].nil? && !params[:date_to].nil?'
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

      def correct_both_dates
        parse_date_to = Date.parse(params[:date_to])
        if parse_date_to > Date.today
          render json: { error: 'La fecha de fin no puede ser mayor a la fecha de hoy.' }, status: :unprocessable_entity
        elsif Date.parse(params[:date_from]) >= parse_date_to
          render json: { error: 'La fecha de fin debe ser mayor que la fecha de inicio.' }, status: :unprocessable_entity
        end
      end

      def correct_date_from
        render json:
        {
          error: 'La fecha de inicio no puede ser mayor que la fecha de hoy.'
        }, status: :unprocessable_entity if Date.parse(params[:date_from]) > Date.today
      end

      def correct_date_to
        render json:
        {
          error: 'La fecha de fin no puede ser mayor que la fecha de hoy.'
        }, status: :unprocessable_entity if Date.parse(params[:date_to]) > Date.today
      end
    end
  end
end
