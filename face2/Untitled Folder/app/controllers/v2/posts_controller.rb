class V2::PostsController < V2::BaseController
  include V2::Authority

  def index
    @posts = search_result.includes(:user).without_not_associating_photos
      .page(params[:page]).uniq
  end

  private
  def save
    case params[:action]
    when "create"
      @post.user_id = current_user.id
      unless @post.save
        head :bad_request and return
      end
    when "update"
      super
    end
  end
end
