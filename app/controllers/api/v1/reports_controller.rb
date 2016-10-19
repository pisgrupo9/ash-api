module Api
  module V1
    class ReportsController < Api::V1::ApiController
      before_action :set_user
      respond_to :json

      def index
        @reports = @user.reports.all
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
