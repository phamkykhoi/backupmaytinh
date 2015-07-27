class V2::AppDriverHistoriesController < V2::BaseController
  skip_before_action :authenticate, only: [:point_up]

  before_action :check_ip_permission, only: [:point_up]

  RESPONSES = {
    error: 0,
    take_point: 1,
    do_not_take_point: 2
  }

  def index
    @app_driver_histories = search_result
  end

  def point_up
    attributes = {
      identifier: params[:identifier],
      achieve_id: params[:achieve_id],
      accepted_time: params[:accepted_time],
      campaign_id: params[:campaign_id],
      campaign_name: params[:campaign_name],
      advertisement_id: params[:advertisement_id],
      advertisement_name: params[:advertisement_name],
      point: params[:point],
      payment: params[:payment],
      increase_ticket: Ticket::INCREASE_TICKET
    }

    if AppDriverHistory.find_by identifier: params[:identifier],
      advertisement_id: params[:advertisement_id]
      if AppDriverHistory.create attributes
        render json: RESPONSES[:do_not_take_point]
      else
        render json: RESPONSES[:error]
      end
    else
      identifier = JSON.parse params[:identifier]
      attributes[:user_id] = identifier["user_id"].to_i
      attributes[:device_id] = identifier["device_id"]
      if AppDriverHistory.create attributes
        render json: RESPONSES[:take_point]
      else
        render json: RESPONSES[:error]
      end
    end
  end

  private
  def check_ip_permission
    ip = request.remote_ip
    AppDriverLogger.info <<-EOS
------------------------------------------
IP: #{ip}
params: #{params}
------------------------------------------
    EOS
    return head :unauthorized unless Settings.ip.allows.include? ip
  end
end
