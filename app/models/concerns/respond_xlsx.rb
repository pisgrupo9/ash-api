module RespondXlsx
  extend ActiveSupport::Concern

  included do
    def respond_excel(file_name, folder, route)
      file = Tempfile.new([file_name, '.xlsx'])
      file.write(render_to_string "#{route}/excel.xlsx.axlsx")
      file.rewind
      file.close
      path = file.path
      name = File.basename(path)
      obj = S3_BUCKET.object("uploads/#{folder}/#{name}")
      obj.upload_file(path)
      @url = obj.public_url
    end
  end
end
