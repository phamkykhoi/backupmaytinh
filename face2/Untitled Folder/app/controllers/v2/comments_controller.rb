class V2::CommentsController < V2::BaseController
  include V2::Authority

  def index
    @comments = search_result.includes :user
  end

  private
  def save
    case params[:action]
    when "create"
      @comment.user_id = current_user.id
      head @comment.save ? :ok : :bad_request
    when "update"
      super
    end
   end
end
