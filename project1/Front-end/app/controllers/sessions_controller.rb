class SessionsController < ApplicationController
  def new
    @user = User.new
    redirect
  end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user)  : forget(@user)
      if current_user.admin
        redirect_to admin_users_path
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to login_path
  end
end