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
        pdf = PdfCreator.new(@animal)
        pdf_name = "perfil_#{@animal.name}_#{Time.now.to_i}".delete(' ')
        pdf.render_file pdf_name
        pdf_final = pdf.file_upload pdf.directory, pdf_name
        @path_to_pdf = pdf_final.public_url
        File.delete pdf_name
        render 'pdf_url.json.jbuilder'
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

      def new_animal
        @species.adoptable? ? @animal = Adoptable.new(adoptable_params) : @animal = Animal.new(animal_params)
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
        @animals = Animal.search(animals_search_params)
        respond_excel('busqueda', 'excel', '/api/v1/animals')
        render 'excel_url.json.jbuilder'
      end

      private

      def set_animal
        @animal = Animal.find(params[:id])
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
                      :species_id, :weight, :type)
      end
    end
  end
end
