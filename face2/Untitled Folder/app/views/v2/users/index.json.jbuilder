json.users @users do |user|
  json.id user.id
  json.name user.name
  json.user_profile_photo_url user.profile_photo.thumb_small.try(:url)
  json.email user.email
  json.facebook_id user.facebook_id
  json.facebook_token user.facebook_token
end