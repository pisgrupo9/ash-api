json.users @users do |user|
  json.(user, :id, :email, :first_name, :last_name, :phone, :account_active, :permissions)
end
