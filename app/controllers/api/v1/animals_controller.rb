module Api
  module V1
    class AnimalsController < Api::V1::ApiController
      include RespondXlsx
      before_action :set_animal, only: [:show, :update, :destroy, :export_pdf]
      respond_to :json

      def index
        @animals = Animal.page(params[:page]).per(params[:row])
        render partial: 'index.json.jbuilder'
      end

      def show
        respond_to do |format|
          format.json { render 'show.json.jbuilder' }
        end
      end

      def export_pdf
        create_report('pdf')
        PdfUploader.new.delay.respond_pdf(@animal, @report.id)
        head :no_content
      end

      def create
        authorize Animal
        @species = Species.find(animal_params[:species_id])
        new_animal
        if @animal.save
          render json: @animal.as_json(only: [:id]), status: :created
        else
          render json: { error: @animal.errors.as_json }, status: :unprocessable_entity
        end
      end

      def update
        authorize Animal
        species.adoptable? ? update_params = adoptable_params : update_params = animal_params
        if @animal.update(update_params)
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

      def search
        @animals = Animal.search(animals_search_params).page(params[:page]).per(params[:row])
        render partial: 'index.json.jbuilder'
      end

      def export_search
        create_report('excel')
        @animals = Animal.search(animals_search_params)
        params_uploader = { file_name: 'busqueda', collection_name: '@animals',
                            folder: 'excel', route: '/api/v1/animals', report_id: @report.id }
        ExcelUploader.new.delay.respond_excel(params_uploader, @animals)
        head :no_content
      end

      private

      def set_animal
        @animal = Animal.find(params[:id])
      end

      def new_animal
        @species.adoptable? ? @animal = Adoptable.new(adoptable_params) : @animal = Animal.new(animal_params)
      end

      def create_report(type_file)
        @user = current_user
        @report = @user.reports.build(name: "Busqueda_#{Time.now.strftime '%Y%m%d%H%M%S'}",
                                      type_file: type_file, state: 'processing')
        @report.save
      end

      def adoptable_params
        params.require(:animal).permit(:chip_num, :name, :race, :sex, :vaccines, :castrated, :admission_date,
                                       :birthdate, :death_date, :species_id, :weight, :profile_image)
      end

      def animal_params
        params.require(:animal).permit(:chip_num, :name, :race, :sex, :admission_date,
                                       :birthdate, :death_date, :species_id, :weight, :profile_image)
      end

      def animals_search_params
        params.permit(:chip_num, :name, :race, :sex, :vaccines, :castrated, :admission_date_from, :admission_date_to,
                      :species_id, :weight, :type, :adopted)
      end
    end
  end
end
