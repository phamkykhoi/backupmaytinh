class Comment < ActiveRecord::Base
  DEFAULT_UPDATABLE_ATTRIBUTES = [:content, :post_id, :user_id]

  has_many :activities, as: :trackable, dependent: :destroy
  has_many :bans, dependent: :destroy, as: :reportable

  belongs_to :post
  belongs_to :user

  counter_culture :post

  validates :post_id, :user_id, :content, presence: true

  after_create :create_activity

  def reported? user
    !self.bans.find_by(user_id: user.id).nil?
  end

  private
  def create_activity
    body = %W(/#{user.name}/ #{M::ActivityTemplate
      .find_by(key: self.class.name).try :text}).join " "
    activity = activities.create user_id: user_id, body: body

    unless post.user == user
      activity.activity_inboxes.create user_id: post.user_id
      content = {message: body.delete("/"), post_id: post.id, target_id: post.id, type: "Comment"}
      if post.user.commented_notice && post.user.login?
        Notification.send_to post.user, content
      end
    end
  end
end
