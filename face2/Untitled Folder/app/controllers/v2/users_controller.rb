class V2::UsersController < V2::BaseController
  prepend_before_action :check_api_token, only: [:create, :password_reset]
  skip_before_action :authenticate, only: [:create, :password_reset]

  def index
    @users = search_result
  end

  def password_reset
    if user = User.find_by(email: params[:user][:email])
      password = SecureRandom.hex 8
      user.update password: password

      UserMailer.delay.reset_password user, password
      return head :ok
    else
      return head :bad_request
    end
  end

  private
  def save
    case params[:action]
    when "create"
      check_and_replace_as_existing_account
      enqueue_for_notification @user if @user.save
    when "update"
      if params[:user][:new_password]
        update_password
      else
        if @user.save
          return render :show
        else
          return head :bad_request
        end
      end
    end
  end

  def update_password
    if @user = instance.try(:authenticate, params[:user][:old_password])
      @user.update password: params[:user][:new_password]
      @user.request_token.generate_token!
      return render :create
    else
      return head :bad_request
    end
  end

  def check_and_replace_as_existing_account
    if @user.facebook_id.present? && @user.facebook_token.present?
      graph = Koala::Facebook::API.new @user.facebook_token

      begin
        ids = graph.get_connections "me", "ids_for_business"
      rescue
        return head :unauthorized
      end

      facebook_ids = ids.each_with_object [] do |id, _facebook_ids|
        if Settings.facebook_app_ids.include? id["app"]["id"]
          _facebook_ids << id["id"]
        end
      end

      FacebookUserMigrationLogger.info <<-EOS
------------------------------------------
facebook_app_ids: #{Settings.facebook_app_ids}
ids: #{ids}
facebook_id: #{@user.facebook_id}
matched: #{facebook_ids.include? @user.facebook_id}
------------------------------------------
      EOS

      if facebook_ids.present? &&
        (user = User.where(facebook_id: facebook_ids).last)
        render_create_as_existing_account user
      end
    end
  end

  def enqueue_for_notification user
    current_datetime = Time.zone.now
    run_at = if (8..22).cover? current_datetime.hour
      Settings.range_to_send_push_notification_for_no_login_user.from_now
    else
      Settings.range_to_send_push_notification_for_no_login_user.from_now
        .beginning_of_day + 8.hours + rand(14).hours
    end

    Notification.delay(queue: queue_name(user), run_at: run_at, priority: 20)
      .send_to user, I18n.t(".no_login_notice")
  end

  def queue_name user
    "users:#{user.id}:no_login_notice"
  end

  def render_create_as_existing_account user
    if @user.oss.present? && !Os.exists_same_as?(@user.oss.first)
      user.oss.create @user.oss.first.attributes
    end
    @user = user
    @user.request_token.generate_token!

    enqueue_for_notification @user
    return render :create
  end
end
