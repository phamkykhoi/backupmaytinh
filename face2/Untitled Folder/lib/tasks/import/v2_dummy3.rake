namespace :import do
  desc "import dummy data for v2"
  task v2_dummy3: :environment do
    puts "Do rake db:seed" and return  unless M::Genre.exists?

    200.times do
      updated_at = Time.zone.now - 1.days
      Supportership.create! post_id: Post.all.sample.id,
        supporter_id: User.all.sample.id, updated_at: updated_at
    end

    200.times do
      updated_at = Time.zone.now - 1.weeks
      Supportership.create! post_id: Post.all.sample.id,
        supporter_id: User.all.sample.id, updated_at: updated_at
    end
  end
end
