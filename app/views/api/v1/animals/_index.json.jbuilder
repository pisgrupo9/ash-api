json.animals @animals do |animal|
  json.name animal.name
  json.id animal.id
  json.chip_num animal.chip_num
  json.race animal.race
  json.sex animal.sex_to_s
  json.weight animal.weight
  json.vaccines animal.vaccines if animal.adoptable?
  json.castrated animal.castrated if animal.adoptable?
  json.admission_date animal.admission_date
  json.birthdate animal.birthdate
  json.death_date animal.death_date
  json.species animal.species.name
  json.species_id animal.species_id
  json.type animal.type
  json.available animal.available? if animal.adoptable?
  json.adopted animal.adopted if animal.adoptable?
  json.profile_image_thumb animal.profile_image.thumb.url
end
json.total_pages @animals.total_pages
