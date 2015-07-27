class V2::RankingHistoriesController < V2::BaseController
  def index
    @ranking_histories = search_result
  end
end
