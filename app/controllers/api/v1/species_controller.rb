module Api
  module V1
    class SpeciesController < Api::V1::ApiController
      def index
        @species = Species.all
      end
    end
  end
end
