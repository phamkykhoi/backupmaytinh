json.followerships @followerships do |followership|
  json.id followership.id
  json.follower_id followership.follower.id
  json.follower_name followership.follower.name
  json.follower_profile_photo_url followership.follower.profile_photo
    .thumb_small.try(:url)
  json.followee_id followership.followee.id
  json.followee_name followership.followee.name
  json.followee_profile_photo_url followership.followee.profile_photo
    .thumb_small.try(:url)
  followee_by_current_user = followership.is_included @followerships_following_current_user, params[:q].keys[0]
  if followee_by_current_user.present?
    json.following_followership_id followee_by_current_user.id
    json.following_followership_status true
  else
    json.following_followership_id ""
    json.following_followership_status false
  end
end
