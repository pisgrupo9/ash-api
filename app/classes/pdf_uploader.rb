class PdfUploader
  def respond_pdf(animal, report_id)
    pdf = PdfCreator.new(animal)
    pdf_name = "perfil_#{animal.name}_#{Time.now.to_i}".delete(' ')
    pdf.render_file pdf_name
    pdf_final = pdf.file_upload pdf.directory, pdf_name
    @path_to_pdf = pdf_final.public_url
    File.delete pdf_name
    report = Report.find(report_id)
    report.update(url: @path_to_pdf, state: 'done')
  end
end
