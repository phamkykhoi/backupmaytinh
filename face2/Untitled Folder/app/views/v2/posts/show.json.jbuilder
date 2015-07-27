json.post do
  json.user_name @post.user.name
  json.user_id @post.user.id
  json.user_profile_photo_url @post.user.profile_photo.thumb_small.try(:url)
  json.m_genre_name @post.m_genre.name
  json.supporters_count_from_user @post.supporters_count_from_user(current_user)
  json.supporters_count @post.supporters_count
  json.reported @post.reported?(current_user)
  json.mine @post.user.id == current_user.id
  json.tags do
    json.array! @post.tags.pluck(:name)
  end
  json.download @post.download
  json.camera_name (@post.camera.try(:name) || "")
  json.location @post.location || ""
  json.photographer_name (@post.photographer.try(:name) || "")
  if @post.photos.present?
    if @post.photos.with_main.content.high_definition.file.exists?
      json.photo1_url @post.photos.with_main.content.high_definition.try(:url)
    else
      json.photo1_url @post.photos.with_main.content_url
    end
    json.photo1_description @post.photos.with_main.description
    json.photo1_width_ratio @post.photos.with_main.width_ratio
    json.photo1_height_ratio @post.photos.with_main.height_ratio
  end
  @post.photos.without_main.each.with_index 2 do |photo, i|
    if photo.content.high_definition.file.exists?
      json.set! "photo#{i}_url", photo.content.high_definition.try(:url)
    else
      json.set! "photo#{i}_url", photo.content_url
    end
    json.set! "photo#{i}_description", photo.description
    json.set! "photo#{i}_width_ratio", photo.width_ratio
    json.set! "photo#{i}_height_ratio", photo.height_ratio
  end
end
