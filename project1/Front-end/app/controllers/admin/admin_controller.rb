class Admin::AdminController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :login_redirect

  protected
  def login_redirect
    unless logged_in? && is_admin?
      redirect_to root_path
    end
  end
end