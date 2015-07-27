class V2::TagsController < V2::BaseController
  def index
    @tags = search_result.page 1
  end
end
