json.reports @reports do |report|
  json.name report.name
  json.url report.url
  json.type_file report.type_file
  json.state report.state_to_s
  json.generated_date report.created_at
end
