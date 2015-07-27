class SessionsController < ApplicationController
  def new
  
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  		flash[:danger] = 'Welcome to the Sample App'
  		log_in @user
  		params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		redirect_back_or @user
  	else
  		flash[:danger] = 'Invalid email/password combination'
  		render "new"	
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to login_path
  end
end