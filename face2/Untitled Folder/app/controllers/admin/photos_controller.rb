class Admin::PhotosController < Admin::BaseController
  def show
    send_data @photo.content.read,
      type: @photo.content.content_type,
      filename: File.basename(@photo.content.url),
      disposition: :attachment
  end

  private
  def set_instance
    @photo = Photo.with_deleted.find params[:id]
  end
end
