class V2::BulletinsController < V2::BaseController
  def index
    @bulletins = Bulletin.all
  end
end
