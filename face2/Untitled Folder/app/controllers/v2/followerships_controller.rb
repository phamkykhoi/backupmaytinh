class V2::FollowershipsController < V2::BaseController
  def index
    @followerships_following_current_user = Followership.where follower_id: current_user.id
    @followerships = search_result
  end

  private
  def save
    case params[:action]
    when "create"
      @followership.follower_id = current_user.id
      return head :bad_request unless @followership.save
    when "update"
      super
    end
  end
end
