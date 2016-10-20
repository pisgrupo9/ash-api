module Api
  module V1
    class EventsController < Api::V1::ApiController
      include RespondXlsx
      before_action :set_animal
      def index
        @events = @animal.events.page(params[:page]).per(params[:row])
        render partial: 'index.json.jbuilder'
      end

      def show
        @event = @animal.events.find(params[:id])
      end

      def create
        authorize @animal
        event = @animal.events.build(event_params)
        if event.save
          render json: event.as_json(only: [:id]), status: :created
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

      def search
        @events = @animal.events.search(search_params).page(params[:page]).per(params[:row])
        render partial: 'index.json.jbuilder'
      end

      def export_events
        create_excel_report
        @events = @animal.events
        params_uploader = { file_name: "eventos_#{@animal.name}", collection_name: '@events',
                            folder: 'excel_events', route: '/api/v1/events', report_id: @report.id }
        ExcelUploader.new.delay.respond_excel(params_uploader, @events)
        head status: :ok
      end

      private

      def create_excel_report
        @user = current_user
        @report = @user.reports.build(name: "Busqueda_#{Time.now.strftime '%Y%m%d%H%M%S'}",
                                      type_file: 'excel', state: 'processing')
        @report.save
      end

      def set_animal
        @animal = Animal.find(params[:animal_id])
      end

      def event_params
        params.require(:event).permit(:name, :description, :date)
      end

      def search_params
        params.permit(:text)
      end
    end
  end
end
