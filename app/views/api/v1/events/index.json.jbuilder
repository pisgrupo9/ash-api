json.events @events do |event|
  json.id event.id
  json.name event.name
  json.description event.description
  json.date event.date
end
json.total_pages @events.total_pages
