class V2::SessionsController < V2::BaseController
  prepend_before_action :check_api_token, only: [:create, :login]
  skip_before_action :authenticate, :build_instance, :save,
    only: [:create, :login]

  def create
    if @user = User.find_by(login_id: params[:user][:login_id])
      return head :forbidden unless @user.request_token.content

      @user.request_token.generate_token!

      delete_queue_for_notification @user
      enqueue_for_notification @user
    else
      return head :bad_request
    end
  end

  def login
    if @user = User.find_by(email: params[:user][:email])
      .try(:authenticate, params[:user][:password])
      @user.request_token.generate_token!

      associate_device_and @user
      enqueue_for_notification @user
    else
      return head :bad_request
    end
  end

  def logout
    if user = User.find_by(login_id: params[:user][:login_id])
      user.request_token.update content: nil, expires_at: Time.zone.now

      disassociate_device_and user
      delete_queue_for_notification user
      return head :ok
    else
      return head :bad_request
    end
  end

  private
  def associate_device_and user
    return unless params[:user][:oss_attributes]

    os = params[:user][:oss_attributes].first
    case os[:type]
    #TODO Remove comment out after finishing implement at iOS
    #when "Ios"
    #  user.ioss.create device_token: os[:device_token]
    when "Android"
      user.androids.create registration_id: os[:registration_id]
    end
  end

  def disassociate_device_and user
    return unless params[:user][:oss_attributes]

    os = params[:user][:oss_attributes].first
    case os[:type]
    #TODO Remove comment out after finishing implement at iOS
    #when "Ios"
    #  ios = user.ioss.find_by device_token: os[:device_token]
    #  ios.destroy if ios
    when "Android"
      android = user.androids.find_by registration_id: os[:registration_id]
      android.destroy if android
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

    content = {message: I18n.t(".no_login_notice"), type: "Normal"}
    Notification.delay(queue: queue_name(user), run_at: run_at, priority: 20)
      .send_to user, content
  end

  def delete_queue_for_notification user
    Delayed::Job.where(queue: queue_name(user)).delete_all
  end

  def queue_name user
    "users:#{user.id}:no_login_notice"
  end
end
