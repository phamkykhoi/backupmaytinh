namespace :import do
  desc "import dummy data for v2"
  task v2_dummy1: :environment do
    puts "Do rake db:seed" and return  unless M::Genre.exists?

    User.create! name: "name", profile_photo: File.open(File.join(Rails.root,
      "db/test_data/files/old_cosplay_photos/test_image2.jpg"))
    User.first.request_token.update! content: "_nCAH3u2J-0Qr2ZwuPFvoQ",
      expires_at: Time.zone.now + 1.year

    200.times do |i|
      User.create! name: "name#{i}", profile_photo: File.open(
        File.join(Rails.root,
          "db/test_data/files/old_cosplay_photos/test_image2.jpg"))
    end
  end
end
