json.app_driver_histories @app_driver_histories do |app_driver_history|
  json.identifier app_driver_history.identifier
  json.achieve_id app_driver_history.achieve_id
  json.accepted_time app_driver_history.accepted_time
  json.campaign_id app_driver_history.campaign_id
  json.campaign_name app_driver_history.campaign_name
  json.advertisement_id app_driver_history.advertisement_id
  json.advertisement_name app_driver_history.advertisement_name
end
