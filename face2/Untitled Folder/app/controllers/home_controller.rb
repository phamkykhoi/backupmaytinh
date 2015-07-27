class HomeController < ApplicationController
  before_action :basic, if: ->{Rails.env.staging?}

  layout "home", only: [:index]

  def index
  end
end
