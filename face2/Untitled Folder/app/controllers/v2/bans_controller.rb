class V2::BansController < V2::BaseController
  private
  def save
    case params[:action]
    when "create"
      @ban.user_id = current_user.id
      head @ban.save ? :ok : :bad_request
    when "update"
      super
    end
  end

  def model_params
    return unless params[model_name_symbol]

    if params[model_name_symbol][:post_id]
      params[model_name_symbol][:reportable_id] =
        params[model_name_symbol][:post_id]
      params[model_name_symbol][:reportable_type] = "Post"
    end

    params.require(model_name_symbol)
      .permit model::DEFAULT_UPDATABLE_ATTRIBUTES
  end
end
