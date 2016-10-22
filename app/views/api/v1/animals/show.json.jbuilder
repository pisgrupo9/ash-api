json.id @animal.id
json.chip_num @animal.chip_num
json.name @animal.name
json.sex @animal.sex_to_s
json.race @animal.race
json.weight @animal.weight
json.vaccines @animal.vaccines if @animal.adoptable?
json.castrated @animal.castrated if @animal.adoptable?
json.admission_date @animal.admission_date
json.birthdate @animal.birthdate
json.death_date @animal.death_date
json.species @animal.species.name
json.species_id @animal.species_id
json.type @animal.type
json.adopted @animal.adopted if @animal.adoptable?
json.adopter_id @animal.adopter.id if @animal.adopter
json.adoption_id @animal.adoption.id if @animal.adoption
json.profile_image @animal.profile_image.url
json.profile_image_thumb @animal.profile_image.thumb.url
json.profile_image_medium @animal.profile_image.medium.url
json.profile_image_maximum @animal.profile_image.maximun.url

