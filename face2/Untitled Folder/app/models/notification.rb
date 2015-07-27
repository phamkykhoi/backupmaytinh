class Notification < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:content]

  paginates_per 50

  class << self
    def send_point_up_to user, advertisement_id
      user.ioss.each do |ios|
        notification = Rpush::Apns::Notification.new
        notification.app = Rpush::Apns::App.find_by name: Settings.ios_app_name
        notification.device_token = ios.device_token
        notification.alert = I18n.t("increase_ticket",
          increase_ticket: Ticket::INCREASE_TICKET)
        notification.data = {
          current_count: user.ticket.current_count,
          next_recover: user.ticket.next_recover,
          advertisement_id: advertisement_id
        }
        notification.save!
      end

      if user.androids.present?
        notification = Rpush::Gcm::Notification.new
        notification.app = Rpush::Gcm::App.find_by name: Settings.android_app_name
        notification.registration_ids = user.androids.pluck :registration_id
        notification.data = {
          message: I18n.t("increase_ticket",
            increase_ticket: Ticket::INCREASE_TICKET),
          current_count: user.ticket.current_count,
          next_recover: user.ticket.next_recover,
          advertisement_id: advertisement_id
        }
        notification.save!
      end
    end

    def send_to user, content
      user.ioss.each do |ios|
        notification = Rpush::Apns::Notification.new
        notification.app = Rpush::Apns::App.find_by name: Settings.ios_app_name
        notification.device_token = ios.device_token
        notification.alert = content[:message]
        notification.save!
      end

      if user.androids.present?
        notification = Rpush::Gcm::Notification.new
        notification.app = Rpush::Gcm::App.find_by name: Settings.android_app_name
        notification.registration_ids = user.androids.pluck :registration_id
        notification.data = content
        notification.save!
      end
    end

    def send_all body
      User.all.find_each do |user|
        send_to user, body
      end
    end
  end
end
