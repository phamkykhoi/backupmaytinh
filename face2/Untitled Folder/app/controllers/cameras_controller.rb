class CamerasController < BaseController
  def index
    @cameras = search_result.page 1
  end
end
