class V2::SupportSubtotalsController < V2::BaseController
  def index
    @support_subtotals = search_result.recent
  end
end
