require 'prawn'
require 'open-uri'

class PdfCreator < Prawn::Document
  Prawn::Font::AFM.hide_m17n_warning = true
    def initialize(animal)
      super()
      @animal = animal
      set_title
      set_data
      set_tabla_eventos
    end

    def file_upload(directory, pdf_name)
      file = directory.files.create(
        key:    "uploads/pdfs/#{pdf_name}.pdf",
        body:   File.open(pdf_name),
        public: true
      )
      file.save
      file
    end

    def directory
      storage = Fog::Storage.new(
        provider:              'AWS',
        aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'sa-east-1'
      )
      storage.directories.get('ash-images')
    end

    def set_title
      text_box "Ficha de #{@animal.name.capitalize}", style: :bold_italic, size: 18, align: :center
      move_down 50
      image open(@animal.profile_image.url), width: 150, at: [50, cursor - 10]
    end

    def set_values
      if @animal.vaccines?
        @vacunado = @animal.vaccines ? 'SI' : 'NO'
      else
        @vacunado = '-'
      end
      if @animal.castrated?
        @castrado = @animal.castrated ? 'SI' : 'NO'
      else
        @castrado = '-'
      end
      if @animal.race?
        @race = @animal.race
      else
        @race = '-'
      end
    end

    def set_data
      set_values
      table([
        ['Número de Chip:', @animal.chip_num || '-'], ['Nombre:', @animal.name.capitalize],
        ['Especie:', @animal.species_name.capitalize], ['Sexo:', @animal.sex_to_s], ['Raza:', @race.capitalize],
        ['Peso:', @animal.weight || '-'], ['Nacimiento:', @animal.birthdate], ['Ingreso:', @animal.admission_date],
        ['Muerte:', @animal.death_date || '-'], ['Vacunado:', @vacunado], ['Castrado:', @castrado]], position: 300) do |table|
        table.cells.padding = 6
        table.cells.borders = []
        table.cells.font_size = 8
      end
    end

    def eventos_title
      move_down 40
      text 'Mis eventos', style: :bold_italic, size: 16, align: :center
      move_down 40
    end

    def set_tabla_eventos
      return unless @animal.events
      eventos_title
      table(set_eventos, position: :center) do |table|
        table.row(0).font_style = :bold
        table.row(0).columns(0..2).align = :center
        table.row(0).columns(0..2).font_size = 11
        table.cells.align = :center
      end
    end

    def set_eventos
      [%w(Fecha, Título, Descripción)] +
        @animal.events.map do |evento|
          [evento.date, evento.name.capitalize, evento.description]
        end
    end
  end
