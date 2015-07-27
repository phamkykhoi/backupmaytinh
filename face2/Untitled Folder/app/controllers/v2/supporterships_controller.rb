class V2::SupportershipsController < V2::BaseController
  def index
    @supporterships = search_result
  end

  private
  def save
    case params[:action]
    when "create"
      @supportership.supporter_id = current_user.id
      return head :bad_request unless @supportership.save
    when "update"
      super
    end
   end
end
