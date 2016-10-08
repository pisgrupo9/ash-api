module Api
  module V1
    class AnimalsController < Api::V1::ApiController
      before_action :set_animal, only: [:show, :update, :destroy]
      respond_to :json

      def index
        @animals = Animal.page(params[:page]).per(params[:row])
        render partial: 'index.json.jbuilder'
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
        if @animal.update(animal_params)
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
        respond_xls
        render 'excel_url.json.jbuilder'
      end

      private

      def respond_xls
        @animals = Animal.search(animals_search_params)
        file = Tempfile.new(['busqueda', '.xls'])
        file.write(render_to_string 'search.xls.erb')
        file.rewind
        file.close
        upload_excel(file)
      end

      def upload_excel(file)
        path = file.path
        name = File.basename(path)
        obj = S3_BUCKET.object("uploads/excel/#{name}")
        obj.upload_file(path)
        url_set(obj)
      end

      def url_set(obj)
        @url = obj.public_url
      end

      def set_animal
        @animal = Animal.find(params[:id])
      end

      def animal_params
        params.require(:animal).permit(:chip_num, :name, :race, :sex, :vaccines, :castrated, :admission_date,
                                       :birthdate, :death_date, :species_id, :weight, :profile_image)
      end

      def animals_search_params
        params.permit(:chip_num, :name, :race, :sex, :vaccines, :castrated, :admission_date, :species_id, :weight)
      end
    end
  end
end
