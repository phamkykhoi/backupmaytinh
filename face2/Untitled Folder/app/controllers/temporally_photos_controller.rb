class TemporallyPhotosController < ApplicationController
  def create
    temporally_photos_dir = "/temporally_photos/#{Time.zone.now.strftime("%Y-%m-%d")}/"
    FileUtils::mkdir_p "public#{temporally_photos_dir}"
    @temporally_photo_url = temporally_photos_dir +
      SecureRandom.hex(8) + params[:file].original_filename.gsub(" ", "_")
    File.binwrite "public#{@temporally_photo_url}", params[:file].read
  end
end
