class V2::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  #force_ssl if: :ssl_configured?

  before_action :authenticate
  before_action :set_config
  before_action :build_instance, only: [:create]
  before_action :set_instance, only: [:update, :destroy, :show]
  before_action :set_params, only: [:update]
  before_action :save, only: [:create, :update]

  helper_method :current_user

  def create
  end

  def show
  end

  def update
  end

  def destroy
    head instance.destroy ? :ok : :bad_request
  end

  private
  def set_config
    I18n.locale = :en
    response.headers["Content-Type"] = "application/json; charset=utf-8"
  end

  def model
    controller_name.classify.safe_constantize
  end

  def model_name
    controller_name.singularize
  end

  def model_name_symbol
    model_name.intern
  end

  def build_instance
    _instance = model.new model_params
    instance_variable_set "@#{model_name}", _instance
  end

  def set_instance
    _instance = model.find params[:id]
    instance_variable_set "@#{model_name}", _instance
  end

  def set_params
    instance.assign_attributes model_params
  end

  def instance
    instance_variable_get "@#{model_name}"
  end

  def model_params
    return unless params[model_name_symbol]
    params.require(model_name_symbol)
      .permit model::DEFAULT_UPDATABLE_ATTRIBUTES
  end

  def save
    head instance.save ? :ok : :bad_request
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.joins(:request_token).find_by(
        "request_tokens.content = ? and request_tokens.expires_at > ?",
         token, Time.zone.now)
      @current_user.present?
    end
  end

  def check_api_token
    unless request.env["HTTP_X_API_TOKEN"] == Rails.application
      .secrets.api_token
      return head :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def ssl_configured?
    Rails.env.production?
  end

  def search_result
    if params[:q]
      model.ransack(params[:q]).result
    else
      model
    end
  end
end
