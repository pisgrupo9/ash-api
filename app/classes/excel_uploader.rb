class ExcelUploader
  def respond_excel(file_name, folder, route, collection, collection_name, report_id)
    file = Tempfile.new([file_name, '.xlsx'])
    ac = ApplicationController.new
    collection_name == 'animals' ? instance_var = '@animals' : instance_var = '@events'
    ac.instance_variable_set(instance_var,collection)
    file.write(ac.render_to_string "#{route}/excel.xlsx.axlsx")
    file.rewind
    file.close
    path = file.path
    name = File.basename(path)
    obj = S3_BUCKET.object("uploads/#{folder}/#{name}")
    obj.upload_file(path)
    @url = obj.public_url
    update_report(report_id)
  end

  def update_report(report_id)
    report = Report.find(report_id)
    report.update(url: @url, state: 'done')
  end
end
