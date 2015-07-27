class FollowersController < ApplicationController
	def index
		@title = "Followers"
		@user  = User.find params[:user_id]
    @users = @user.followers.paginate page: params[:page]
	end
end
