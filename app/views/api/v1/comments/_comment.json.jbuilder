json.id comment.id
json.adopter_id comment.adopter_id
json.user_id comment.user_id
json.user_first_name User.find(comment.user_id).first_name
json.user_last_name User.find(comment.user_id).last_name
json.text comment.text
json.date comment.created_at
