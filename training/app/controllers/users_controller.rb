class UsersController < ApplicationController
	def index
		@users = User.all
	end

	def new
		@users = User.new
	end

	def edit
		
	end

	def create
		form_params = user_params;
		@users = User.new user_params
		if @users.save
			@user_login = User.find_by(email:form_params[:email].downcase)
  		@user_login.authenticate(form_params[:password])
  		log_in @user_login
			
			flash[:success] = "Signuped successfull!"
			redirect_to root_path
			
		else
			render "new"
		end
	end

	def update
		
	end

	def show
		
	end

	def destroy
		
	end

	private
	  def user_params
	  	params.require(:user).permit(:fullname, :email, :phone, :password, :password_confirmation)
	  end
end
