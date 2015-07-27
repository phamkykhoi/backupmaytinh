class Bulletin < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:content]

  has_many :activities, as: :trackable, dependent: :destroy

  validates :content, presence: true

  paginates_per 10

  scope :latest, ->{order updated_at: :desc}

  after_create :create_activity

  private
  def create_activity
    body = M::ActivityTemplate.find_by(key: self.class.name).try(:text).to_s
    activity = activities.create body: body
    activity.activity_inboxes.create

    content = {message: body.delete("/"), type: "Normal"}
    Notification.delay(priority: 10).send_all content
  end
end
