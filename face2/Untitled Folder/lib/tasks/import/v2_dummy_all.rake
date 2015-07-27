namespace :import do
  desc "import dummy data for v2"
  task v2_dummy_all: :environment do
    puts "Do rake db:seed" and return  unless M::Genre.exists?

    User.create! name: "name", profile_photo: File.open(File.join(Rails.root,
      "db/test_data/files/old_cosplay_photos/test_image2.jpg"))
    User.first.request_token.update! content: "_nCAH3u2J-0Qr2ZwuPFvoQ",
      expires_at: Time.zone.now + 1.year

    25.times do |i|
      User.create! name: "name#{i}", profile_photo: File.open(
        File.join(Rails.root,
          "db/test_data/files/old_cosplay_photos/test_image2.jpg"))
    end

    50.times do
      follower = User.all.sample
      followee = User.where.not(id: follower.id).sample
      Followership.find_or_create_by follower_id: follower.id, followee_id: followee.id
    end

   50.times do
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

    100.times do
      datetime = Time.zone.now - 1.months
      Supportership.create! post_id: Post.all.sample.id,
        supporter_id: User.all.sample.id, updated_at: datetime,
        created_at: datetime
    end

    100.times do
      datetime = Time.zone.now - 1.weeks
      Supportership.create! post_id: Post.all.sample.id,
        supporter_id: User.all.sample.id, updated_at: datetime,
        created_at: datetime
    end

    100.times do
      datetime = Time.zone.now - 1.days
      Supportership.create! post_id: Post.all.sample.id,
        supporter_id: User.all.sample.id, updated_at: datetime,
        created_at: datetime
    end

    50.times do
      Comment.create! user_id: User.all.sample.id, post_id: Post.all.sample.id,
        content: "content"
    end

    Camera.create name: "camera"
    Tag.create name: "tag"
  end
end
