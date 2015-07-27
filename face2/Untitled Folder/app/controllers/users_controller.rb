class UsersController < BaseController
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :build_instance, only: [:create]
  skip_before_action :save, only: [:create]

  def index
    @users = search_result.page 1
  end

  def create
    if env["omniauth.auth"].present?
      facebook_token = env["omniauth.auth"]["credentials"]["token"]
      graph = Koala::Facebook::API.new facebook_token
      begin
        ids = graph.get_connections "me", "ids_for_business"
      rescue
        flash[:error] = I18n.t "sign_in.need_sign_up"
        return redirect_to sign_in_path
      end

      facebook_ids = ids.each_with_object [] do |id, _facebook_ids|
        if Settings.facebook_app_ids.include? id["app"]["id"]
          _facebook_ids << id["id"]
        end
      end

      if facebook_ids.present? &&
        (user = User.where(facebook_id: facebook_ids).last)
        sign_in user
        redirect_back
      else
        flash[:error] = I18n.t "sign_in.need_sign_up"
        redirect_to sign_in_path
      end
    end
  end
end
