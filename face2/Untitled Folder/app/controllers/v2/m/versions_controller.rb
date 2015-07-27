class V2::M::VersionsController < V2::BaseController
  skip_before_action :set_instance, only: [:show]

  def show
    @status = M::Version.check params[:version], params[:device]
    return head :bad_request unless @status
  end
end
