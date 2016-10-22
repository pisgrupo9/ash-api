json.id adopter.id
json.ci adopter.ci
json.first_name adopter.first_name
json.last_name adopter.last_name
json.email adopter.email
json.phone adopter.phone
json.house_description adopter.house_description
json.blacklisted adopter.blacklisted
json.home_address adopter.home_address
json.adoptions adopter.adoptions do |adoption|
  json.animal_id adoption.animal_id
  json.adoption_id adoption.id
end
