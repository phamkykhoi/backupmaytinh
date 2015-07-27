json.comments @comments do |comment|
  json.id comment.id
  json.user_id comment.user_id
  json.user_name comment.user.name
  json.user_profile_photo_url comment.user.profile_photo.thumb_small.try(:url)
  json.content comment.content
  json.updated_at comment.updated_at
  json.reported comment.reported?(current_user)
  json.mine comment.user_id == current_user.id
end
