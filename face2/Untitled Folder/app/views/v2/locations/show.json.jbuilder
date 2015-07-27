json.location do
  if @location.present?
    json.country_code2 @location.country_code2
    json.country_code3 @location.country_code3
    json.country_name @location.country_name
    json.region_name @location.region_name
    json.city_name @location.city_name
  end
end
