namespace :import do
  desc "import dummy data for v2"
  task v2_dummy2: :environment do
    puts "Do rake db:seed" and return  unless M::Genre.exists?

    500.times do
      photo_path = "db/test_data/files/old_cosplay_photos/test_image1.jpg"
      photo_size = FastImage.size photo_path
      greatest_common_divisor = photo_size[0].gcd photo_size[1]

      Post.create! user_id: User.all.sample.id,
        m_genre_id: M::Genre.all.sample.id,
        photos_attributes: [
          {
            main: true,
            content: File.open(File.join(Rails.root, photo_path)),
            description: "description",
            width_ratio: (photo_size[0] / greatest_common_divisor),
            height_ratio: (photo_size[1] / greatest_common_divisor)
          }
        ]
    end
  end
end
