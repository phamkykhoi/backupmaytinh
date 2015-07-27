class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @user = User.find current_user
    else
      flash[:danger] = "Please log in take access system"
      redirect_to login_path
    end
  end
end
