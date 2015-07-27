json.activities @activities do |activity|
  json.user_profile_photo_url activity.try(:user).try(:profile_photo)
    .try(:thumb_small).try :url
  json.target_photo_url activity.target_photo_url
  json.body activity.body
  json.updated_at activity.updated_at
  json.type activity.trackable_type
  json.target_id activity.target_id
  json.destination_id activity.destination_id
end
json.total_count @activities.total_count
