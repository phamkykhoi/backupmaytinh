class Activity < ActiveRecord::Base
  paginates_per Settings.returning_activity_num

  has_many :activity_inboxes, dependent: :destroy

  belongs_to :trackable, polymorphic: true
  belongs_to :user

  scope :recent, ->boolean = true do
    order updated_at: :desc
  end

  def target_photo_url
    case trackable_type
    when Post.name
      trackable.photos.with_main.content.thumb_small.try :url
    when Supportership.name
      trackable.post.photos.with_main.content.thumb_small.try :url
    when Comment.name
      trackable.post.photos.with_main.content.thumb_small.try :url
    when Followership.name
      trackable.followee.profile_photo.thumb_small.try :url
    when Bulletin.name
      nil
    end
  end

  def target_id
    case trackable_type
    when Post.name
      trackable.user_id
    when Supportership.name
      trackable.post_id
    when Comment.name
      trackable.post_id
    when Followership.name
      trackable.follower_id
    end
  end

  def destination_id
    case trackable_type
    when Post.name
      trackable.id
    when Supportership.name
      trackable.post_id
    when Comment.name
      trackable.post_id
    when Followership.name
      trackable.follower_id
    end
  end

  class << self
    def ransackable_scopes auth_object= nil
      %i(recent)
    end
  end
end
