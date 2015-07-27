class Admin::UsersController < ApplicationController
  before_action :login_redirect_admin

  def index
    @users = User.paginate page: params[:page], per_page: 10
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      flash.now[:success] = "Update user success"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def create
    @user = User.new user_params
    if @user.save
      flash.now[:success] = "Create user success"
      redirect_to admin_users_path
    else
      render "new"
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_path
  end

  private
  
  def user_params
    params.require(:user).permit :fullname, :email,
      :password, :password_confirmation, :avatar
  end
end