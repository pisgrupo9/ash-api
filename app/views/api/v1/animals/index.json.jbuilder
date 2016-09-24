json.animals @animals do |animal|
  json.name animal.name
  json.id animal.id
  json.chip_num animal.chip_num
  json.name animal.name
  json.sex animal.sex_to_s
  json.weight animal.weight
  json.vaccines animal.vaccines
  json.castrated animal.castrated
  json.admission_date animal.admission_date
  json.birthdate animal.birthdate
  json.death_date animal.death_date
  json.species animal.species.name
  json.species_id animal.species_id
  json.profile_image_thumb animal.profile_image.thumb.url
end
