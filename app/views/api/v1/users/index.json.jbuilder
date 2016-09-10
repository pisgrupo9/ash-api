json.users @users do |user|
  json.id user.id
  json.email user.email
  json.first_name user.first_name
  json.last_name user.last_name
  json.phone user.phone
  json.account_active user.account_active
  json.permissions user.permissions
end
