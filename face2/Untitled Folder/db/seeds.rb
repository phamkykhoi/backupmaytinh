require "csv"

if M::RankingType.count == 0
  [:ranking_type, :genre, :activity_template, :version].each do |klass|
    CSV.open("#{Rails.root}/db/masters/#{klass}s.csv",
      {headers: true, header_converters: :downcase}).each do |row|
      "M::#{klass.to_s.classify}".safe_constantize.try :create, row.to_hash
    end
  end

  [:bulletin].each do |klass|
    CSV.open("#{Rails.root}/db/seeds/#{klass}s.csv",
      {headers: true, header_converters: :downcase, col_sep: "::"}).each do |row|
      klass.to_s.classify.safe_constantize.try :create, row.to_hash
    end
  end
end

if Admin.count == 0
  password = "12345678"
  Admin.create email: "admin@cosplay-no1.com", password: password,
    password_confirmation: password
end

unless Rails.env.test?
  if Rpush::Apns::App.count == 0
    ios_app = Rpush::Apns::App.new
    ios_app.name = Settings.ios_app_name
    ios_app.certificate = File.read(Settings.apns.certificate_path)
    ios_app.environment = Settings.apns.environment
    ios_app.password = Settings.apns.password.to_s
    ios_app.connections = 1
    ios_app.save!
  end

  if Rpush::Gcm::App.count == 0
    android_app = Rpush::Gcm::App.new
    android_app.name = Settings.android_app_name
    android_app.auth_key = Settings.gcm.auth_key
    android_app.connections = 1
    android_app.save!
  end
end
