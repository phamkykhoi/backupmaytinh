class FollowingsController < ApplicationController
	def index
		@title = "Following"
    @user  = User.find params[:user_id]
    @users = @user.following.paginate page: params[:page]
	end
end
