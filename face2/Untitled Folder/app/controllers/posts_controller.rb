class PostsController < BaseController
  NEW_CAMERA_PREFEX_REGEX = /\Anew_camera_(.+)/
  NEW_TAG_PREFEX_REGEX = /\Anew_tag_(.+)/
  NEW_USER_PREFEX_REGEX = /\Anew_user_(.+)/

  skip_before_action :basic, only: [:show], if: ->{Rails.env.staging?}
  skip_before_action :authenticate_user!, only: [:show]

  def new
    @post.photos.new
    @photos = []
  end

  private
  def save
    if @post.save
      redirect_to new_post_path, notice: I18n.t("successes.posting_photo")
    else
      flash.now[:error] = I18n.t "errors.fail_creating_post"
      @photos = if @post.photos.blank?
        []
      else
        @post.photos.map do |photo|
          {
            description: photo.description,
            temporally_photo_url: photo.temporally_photo_url
          }
        end
      end
      @post.photos.reload
      @post.photos.new
      render :new
    end
  end

  def model_params
    return unless params[:post]

    params[:post][:from] ||= "web"
    params[:post][:user_id] ||= current_user.id

    if NEW_CAMERA_PREFEX_REGEX =~ params[:post][:camera_id]
      camera = Camera.create name: $1
      params[:post][:camera_id] = camera.id
    end

    if NEW_USER_PREFEX_REGEX =~ params[:post][:photographer_id]
      user = User.create name: $1, only_photographer: true
      params[:post][:photographer_id] = user.id
    end

    params[:post][:tag_ids] = params[:post][:tag_ids].first.split(",")
      .delete_if{|tag_id| tag_id == "[]"}
      .each_with_object [] do |tag_id, _tag_ids|
      if NEW_TAG_PREFEX_REGEX =~ tag_id
        tag_id = Tag.create(name: $1).id.to_s
      end

      _tag_ids.push tag_id
    end

    if photos_attributes = params[:post][:photos_attributes]
      photos_attributes.delete_if do |key, photo|
        photo[:temporally_photo_url] == ""
      end

      photos_attributes.each_with_index do |(key, photo), index|
        if index == 0
          photo[:main] = true
        else
          photo[:main] = false
        end
      end
    else
      return nil
    end

    params.require(:post)
      .permit Post::DEFAULT_UPDATABLE_ATTRIBUTES
  end
end
