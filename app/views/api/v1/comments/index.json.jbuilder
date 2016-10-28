json.comments @comments do |comment|
  json.partial! 'api/v1/comments/comment.json.jbuilder', comment: comment
end
json.total_pages @comments.total_pages
