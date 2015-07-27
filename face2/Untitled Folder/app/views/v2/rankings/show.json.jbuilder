json.ranking do
  json.m_genre_id @ranking.m_genre_id
  json.range @ranking.class::RANGE
  json.ranking_subtotals(@ranking.ranking_subtotals.ordered_by_rank_asc
    .limit(Settings.returning_ranking_subtotal_num)) do |ranking_subtotal|
    json.user_name (ranking_subtotal.try(:user).try(:name).presence ||
      Settings.no_user_name)
    json.user_profile_photo_url ranking_subtotal.try(:user).try(:profile_photo)
      .try(:thumb_small).try :url
    json.user_id ranking_subtotal.user_id
    json.rank ranking_subtotal.rank
    json.supportings_count ranking_subtotal.supportings_count
    json.supporter_photos ranking_subtotal.supporter_photos
  end
end
