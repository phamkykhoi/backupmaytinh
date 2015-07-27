class AppDriverHistory < ActiveRecord::Base
  belongs_to :user

  validates :identifier, :achieve_id, :accepted_time, :campaign_id,
    :campaign_name, :advertisement_id, :advertisement_name, :point, :payment,
    presence: true

  after_create :point_up, if: ->{user_id}

  private
  def point_up
    user.ticket.update increase: Ticket::INCREASE_TICKET
    Notification.send_point_up_to user, advertisement_id
  end
end
