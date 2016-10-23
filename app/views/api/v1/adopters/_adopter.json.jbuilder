json.id adopter.id
json.ci adopter.ci
json.first_name adopter.first_name
json.last_name adopter.last_name
json.email adopter.email
json.phone adopter.phone
json.house_description adopter.house_description
json.blacklisted adopter.blacklisted
json.home_address adopter.home_address
json.animals adopter.animals do |animal|
  json.adoption_id animal.adoption.id
  json.id animal.id
  json.name animal.name
  json.chip_num animal.chip_num
  json.race animal.race
  json.sex animal.sex_to_s
  json.weight animal.weight
  json.vaccines animal.vaccines
  json.castrated animal.castrated
  json.admission_date animal.admission_date
  json.birthdate animal.birthdate
  json.death_date animal.death_date
  json.species animal.species.name
  json.species_id animal.species_id
  json.type animal.type
  json.adopted animal.adopted
  json.profile_image_thumb animal.profile_image.thumb.url
end
