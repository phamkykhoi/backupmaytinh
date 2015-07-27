class BaseController < ApplicationController
  include SessionsHelper

  force_ssl if: :ssl_configured?

  before_action :basic, if: ->{Rails.env.staging?}
  before_action :authenticate_user!
  before_action :set_config
  before_action :build_instance, only: [:new, :create]
  before_action :set_instance, only: [:update, :destroy, :show]
  before_action :set_params, only: [:update]
  before_action :save, only: [:create, :update]

  def new; end
  def create; end

  private
  def search_result
    if params[:q]
      model.ransack(params[:q]).result
    else
      model.all
    end
  end

  def set_config
    I18n.locale = :en
  end

  def authenticate_user!
    unless signed_in?
      store_location
      redirect_to sign_in_path
    end
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
    redirect_to instance.save ? instance : :back
  end

  def ssl_configured?
    Rails.env.production?
  end
end
