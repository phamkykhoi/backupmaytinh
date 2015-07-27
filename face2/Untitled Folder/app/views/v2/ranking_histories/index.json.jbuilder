json.ranking_histories @ranking_histories do |ranking_history|
  json.daily_1 ranking_history.daily_1
  json.daily_2 ranking_history.daily_2
  json.daily_3 ranking_history.daily_3
  json.monthly_1_3 ranking_history.monthly_1_3
  json.monthly_4_10 ranking_history.monthly_4_10
  json.monthly_11_50 ranking_history.monthly_11_50
end
