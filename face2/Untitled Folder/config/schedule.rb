set :output, error: "#{Whenever.path}/log/crontab_error.log",
  standard: "#{Whenever.path}/log/crontab.log"

env :MYSQL_HOST, ENV["MYSQL_HOST"]
env :MYSQL_USERNAME, ENV["MYSQL_USERNAME"]
env :MYSQL_PASSWORD, ENV["MYSQL_PASSWORD"]
env :SECRET_KEY_BASE, ENV["SECRET_KEY_BASE"]
env :DEVISE_SECRET_KEY, ENV["DEVISE_SECRET_KEY"]
env :API_TOKEN, ENV["API_TOKEN"]
env :AWS_ACCESS_KEY_ID, ENV["AWS_ACCESS_KEY_ID"]
env :AWS_SECRET_ACCESS_KEY, ENV["AWS_SECRET_ACCESS_KEY"]
env :AWS_REGION, ENV["AWS_REGION"]
env :S3_BUCKET_NAME, ENV["S3_BUCKET_NAME"]
env :APNS_CERTIFICATE_PATH, ENV["APNS_CERTIFICATE_PATH"]
env :APNS_PASSWORD, ENV["APNS_PASSWORD"]
env :GCM_AUTH_KEY, ENV["GCM_AUTH_KEY"]
env :AWS_SES_ADDRESS, ENV["AWS_SES_ADDRESS"]
env :AWS_SES_USER_NAME, ENV["AWS_SES_USER_NAME"]
env :AWS_SES_PASSWORD, ENV["AWS_SES_PASSWORD"]
env :CARRIER_WAVE_ASSET_HOST, ENV["CARRIER_WAVE_ASSET_HOST"]

every 1.day, at: "16:15 pm" do
  rake "aggregate:daily_ranking"
end

every :sunday, at: "16:30 pm" do
  rake "aggregate:weekly_ranking"
end

=begin
every "45 16 1 * *" do
  rake "aggregate:monthly_ranking"
end

every "15 17 1 * *" do
  rake "aggregate:genre_ranking"
end
=end
