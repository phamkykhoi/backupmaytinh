namespace :migrate do
  desc "Generate image"
  task generate_image: :environment do
    Photo.with_deleted.all.find_each do |photo|
      photo.content.recreate_versions! if photo.content?
    end
  end
end