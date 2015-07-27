class V2::CamerasController < V2::BaseController
  def index
    @cameras = search_result.page 1
  end
end
