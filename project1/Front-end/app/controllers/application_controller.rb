class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  protected
  
  def login_redirect_admin
    unless logged_in? && is_admin?
      redirect_to root_path
    end
  end
end
