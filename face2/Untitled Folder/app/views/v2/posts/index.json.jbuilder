json.posts @posts do |post|
  json.id post.id
  json.user_name post.user.name
  json.user_id post.user_id
  json.supporters_count post.supporters_count
  json.followers_count post.user.followers_count
  json.numberFollower post.user.followers_count
  if post.photos.with_main.content.present? &&
    post.photos.with_main.content.thumb_small.present?
    json.photo_url post.photos.with_main.content.thumb_small.url
    json.width_ratio post.photos.with_main.width_ratio
    json.height_ratio post.photos.with_main.height_ratio
    json.description post.photos.with_main.description
    json.background_color post.photos.with_main.background_color
  end
  post.photos.without_main.each.with_index 2 do |photo, i|
    if photo.content.present? && photo.content.thumb_small.present?
      json.set! "photo#{i}_url", photo.content.thumb_small.url
      json.set! "photo#{i}_width_ratio", photo.width_ratio
      json.set! "photo#{i}_height_ratio", photo.height_ratio
      json.set! "photo#{i}_description", photo.description
    end
  end
end
json.total_count @posts.total_count
