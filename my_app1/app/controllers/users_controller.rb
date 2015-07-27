class UsersController < ApplicationController

  def index
    
  end

  def new 
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])  
  end

  def update
    @user = User.find(params[:id])
 
    if @user.update user_params
      redirect_to users_path
    else
      render 'edit'
    end
  rescue ActiveRecord::StaleObjectError
    @user.reload
    render action: 'conflict'
  end

  def show
    @micropost = Micropost.new
    @user  = User.find(params[:id])
    @posts = @user.microposts.paginate(page: params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    
    if @user.nil?
      render text: "Da Bi Xoa"
    else
      @user.destroy
      redirect_to users_path
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private
    def user_params
      params.require(:user).permit(:fullname, :email, :address, :phone, :avarta)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      flash[:danger] = "You haven't permision destroy"
      redirect_to(root_url) unless current_user.admin?
    end

end
