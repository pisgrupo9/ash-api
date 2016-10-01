json.id @event.id
json.name @event.name
json.description @event.description
json.date @event.date
json.images @event.images.page(params[:page]).per(params[:row]) do |image|
  json.id image.id
  json.url image.file.url
  json.thumb image.file.thumb.url
  json.medium image.file.medium.url
  json.maximum image.file.maximun.url
end
json.total_pages @event.images.page(params[:page]).per(params[:row]).total_pages
