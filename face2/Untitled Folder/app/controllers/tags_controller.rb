class TagsController < BaseController
  def index
    @tags = search_result.page 1
  end
end
