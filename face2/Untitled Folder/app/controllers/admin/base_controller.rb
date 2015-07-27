class Admin::BaseController < ApplicationController
  force_ssl if: :ssl_configured?

  layout "admin"

  skip_before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :create_instance, only: [:create]
  before_action :set_instance, only: [:show, :update, :destroy]
  before_action :set_instances, only: [:index]

  def index
  end

  def create
  end

  def update
  end

  def destroy
    instance.destroy
    redirect_to :back
  end

  private
  def model_name
    controller_name.singularize
  end

  def model_name_symbol
    model_name.intern
  end

  def model
    model_name.classify.safe_constantize
  end

  def set_instances
    instance_variable_set "@#{model_name.pluralize}",
      model.all.page(params[:page])
  end

  def instance
    instance_variable_get "@#{model_name}"
  end

  def set_instance
    model_instance = model.find params[:id]
    instance_variable_set "@#{model_name}", model_instance
  end

  def create_instance
    _instance = model.new model_params
    instance_variable_set "@#{model_name}", _instance
  end

  def model_params
    params.require(model_name_symbol)
      .permit model::DEFAULT_UPDATABLE_ATTRIBUTES
  end

  def ssl_configured?
    Rails.env.production?
  end
end
