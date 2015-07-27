class V2::RankingsController < V2::BaseController
  caches_page :index, :show

  def index
    @rankings = Ranking.includes(:m_ranking_type).current
      .ordered_by_custom_order
  end

  private
  def set_instance
    _instance = model.includes(ranking_subtotals: :user).find params[:id]
    instance_variable_set "@#{model_name}", _instance
  end
end
