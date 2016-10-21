class ExcelUploader
  def respond_excel(params_uploader, collection)
    @file = Tempfile.new([params_uploader[:file_name], '.xlsx'])
    @ac = ApplicationController.new
    @ac.instance_variable_set(params_uploader[:collection_name], collection)
    file_write(params_uploader[:route])
    upload_to_aws(params_uploader[:folder], params_uploader[:report_id], @path)
  end

  def file_write(route)
    @file.write(@ac.render_to_string("#{route}/excel.xlsx.axlsx"))
    @file.rewind
    @file.close
    @path = @file.path
  end

  def upload_to_aws(folder, report_id, path)
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
