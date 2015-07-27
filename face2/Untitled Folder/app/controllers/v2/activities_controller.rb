class V2::ActivitiesController < V2::BaseController
  before_action :build_params, only: [:index]

  def index
    @activities = search_result.includes(:user, :trackable)
      .where.not("activity_inboxes.id" => nil).page params[:page]
  end

  private
  def build_params
    params[:q] = {
      m: "or",
      activity_inboxes_user_id_eq: current_user.id,
      activity_inboxes_user_id_null: 1,
      recent: true
    }
  end
end
