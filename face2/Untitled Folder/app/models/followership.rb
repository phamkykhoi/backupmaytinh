class Followership < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:follower_id, :followee_id]

  has_many :activities, as: :trackable, dependent: :destroy

  belongs_to :followee, class_name: "User"
  belongs_to :follower, class_name: "User"

  counter_culture :followee, column_name: :followers_count
  counter_culture :follower, column_name: :followings_count

  validates :follower_id, :followee_id, presence: true
  validate :can_not_follow_myself

  after_create :create_activity

  validates :follower_id, uniqueness: {scope: :followee_id}

  def is_included followerships, followership_type
    if followership_type == "follower_id_eq"
      followerships.find_by followee_id: self.followee_id
    else
      followerships.find_by followee_id: self.follower_id
    end
  end

  private
  def can_not_follow_myself
    if follower_id == followee_id
      errors.add :followee_id, I18n.t("errors.can_not_be_same_followee")
      errors.add :follower_id, I18n.t("errors.can_not_be_same_follower")
    end
  end

  def create_activity
    body = %W(/#{follower.name}/ #{M::ActivityTemplate
      .find_by(key: self.class.name).try :text}).join " "
    activity = activities.create user_id: follower_id, body: body
    activity.activity_inboxes.create user_id: followee_id
    content = {message: body.delete("/"), user_id: follower_id, target_id: follower_id, type: "Followership" }
    if followee.followed_notice && followee.login?
      Notification.send_to followee, content
    end
  end
end
