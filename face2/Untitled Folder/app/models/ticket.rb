class Ticket < ActiveRecord::Base
  INCREASE_TICKET = 10
  RECOVER_TIME = Settings.recover_time
  DEFAULT_MAX_COUNT = 15

  belongs_to :user

  attr_accessor :next_recover, :increase, :decrease, :limited

  before_create :init

  def decrease= value
    if self.current_count == 0 || value.to_i == 0 ||
      value.to_i > self.current_count
      self.limited = true if value.to_i > self.current_count

      return nil
    else
      value = value.to_i
    end

    if self.over_count == 0
      current_datetime = Time.zone.now
      self.recovers_all_at = if self.recovers_all_at > current_datetime
        self.recovers_all_at + value * self.recover_time
      else
        current_datetime + value * self.recover_time
      end

      enqueue_for_notification
    else
      self.over_count -= value
    end
  end

  def increase= value
    if value.to_i == 0
      return nil
    else
      value = value.to_i
    end

    if self.max_count >= (self.current_count + value)
      self.recovers_all_at = self.recovers_all_at - self.recover_time * value

      enqueue_for_notification
    else
      self.over_count = self.current_count + value - self.max_count

      delete_queue_for_notification
    end
  end

  def current_count
    if over_count == 0
      current_datetime = Time.zone.now
      if recovers_all_at > current_datetime
        _current_count = max_count - ((recovers_all_at - current_datetime) /
          recover_time).ceil
        _current_count > 0 ? _current_count : 0
      else
        max_count
      end
    else
      over_count + max_count
    end
  end

  def next_recover
    return 0 if current_count >= max_count

    ((recovers_all_at - Time.zone.now) % recover_time).to_i
  end

  private
  def init
    self.over_count = 0
    self.max_count = DEFAULT_MAX_COUNT
    self.recover_time = RECOVER_TIME
    self.recovers_all_at = Time.zone.now
  end

  def enqueue_for_notification
    return unless self.user.ticket_recover_notice

    delete_queue_for_notification

    content = {message: I18n.t(".ticket_recover_notice"), type: "Normal"}
    Notification.delay(queue: queue_name, run_at: self.recovers_all_at,
      priority: 30).send_to self.user, content
  end

  def delete_queue_for_notification
    Delayed::Job.where(queue: queue_name).delete_all
  end

  def queue_name
    "users:#{self.user.id}:ticket_recover_notice"
  end
end
