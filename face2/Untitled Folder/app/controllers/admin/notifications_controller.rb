class Admin::NotificationsController < Admin::BaseController
  def index
    @notification = Notification.new
  end

  def create
    if @notification.save
      redirect_to admin_notifications_path
    else
      render :index
    end
  end
end
