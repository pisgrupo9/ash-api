json.images @images do |image|
  json.id image.id
  json.url image.file.url
  json.thumb image.file.thumb.url
  json.medium image.file.medium.url
  json.maximum image.file.maximun.url
end
