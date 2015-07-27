json.rankings @rankings do |ranking|
  json.id ranking.id
  json.name ranking.m_ranking_type.name
  json.range ranking.range
  json.top_ranker_name ranking.top_ranker_name.presence || ""
  json.ranker_photos ranking.ranker_photos ? ranking.ranker_photos : Array.new
end
