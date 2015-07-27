class Admin::UsersController < Admin::BaseController
  def update
    if params[:default_profile_photo]
      default_profile_photo_url = "#{Rails.root}/db/seeds/avatar_defaut.png"
      @user.update profile_photo: File.open(default_profile_photo_url)
    end
    redirect_to :back
  end

  private
  def set_instances
    @search = User.ransack(params[:q])
    @users = @search.result.includes(:posts).recent.page(params[:page])
      .per(Settings.returning_user_num_for_admin)
  end
end
