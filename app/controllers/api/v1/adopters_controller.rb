module Api
  module V1
    class AdoptersController < Api::V1::ApiController
      before_action :set_adopter, only: [:show, :update, :destroy]
      respond_to :json

      def index
        @adopters = Adopter.page(params[:page]).per(params[:row])
      end

      def show
      end

      def create
        authorize Adopter
        adopter = Adopter.new(adopter_params)
        if adopter.save
          render json: adopter.as_json(only: [:id]), status: :created
        else
          render json: { error: adopter.errors.as_json }, status: :unprocessable_entity
        end
      end

      def update
        authorize Adopter
        if @adopter.update(adopter_params)
          render json: @adopter.as_json(only: [:id]), status: :ok
        else
          render json: { error: @adopter.errors.as_json }, status: :bad_request
        end
      end

      def destroy
        authorize Adopter
        @adopter.destroy
        head :no_content
      end

      def search
        @adopters = Adopter.search(adopters_search_params).page(params[:page]).per(params[:row])
        render 'index.json.jbuilder'
      end

      private

      def set_adopter
        @adopter = Adopter.find(params[:id])
      end

      def adopter_params
        params.require(:adopter).permit(:first_name, :last_name, :ci, :email,
                                        :phone, :house_description, :blacklisted, :home_address)
      end

      def adopters_search_params
        params.permit(:name, :blacklisted)
      end
    end
  end
end
