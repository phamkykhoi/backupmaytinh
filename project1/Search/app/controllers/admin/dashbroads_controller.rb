class Admin::DashbroadsController < ApplicationController
  before_action :login_redirect_admin
  
  def home
  end
end