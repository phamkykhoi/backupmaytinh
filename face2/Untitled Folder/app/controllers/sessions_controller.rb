class SessionsController < BaseController
  skip_before_action :authenticate_user!, only: [:create, :new]
  skip_before_action :set_instance, only: [:destroy]
  skip_before_action :build_instance, only: [:new, :create]
  skip_before_action :save, only: [:create]

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back
    else
      flash.now[:error] = I18n.t "sign_in.failure"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
