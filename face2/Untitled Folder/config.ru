require ::File.expand_path("../config/environment", __FILE__)
run Rails.application

ActiveSupport.on_load :after_initialize do
  Rpush.embed
end
