json.supporterships @supporterships do |supportership|
  json.user_id supportership.supporter_id
  json.user_name (supportership.try(:supporter).try(:name).presence ||
    Settings.no_user_name)
  json.user_profile_photo_url supportership.try(:supporter).try(:profile_photo)
    .try(:thumb_small).try :url
  json.supportings_count supportership.supportings_count
end
