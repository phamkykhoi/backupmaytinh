class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = I18n.t "message.create"
      redirect_to admin_users_path
    else
      render "new"
    end
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      flash[:success] = I18n.t "message.update"
      redirect_to admin_users_path
    else
      render "edit"
    end
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t "message.delete"
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit :role, :fullname, :email,
      :address, :phone, :gender, :avata, :password, :password_confirmation
  end
end